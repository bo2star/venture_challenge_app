class ShopSynchronizer

  WEBHOOK_TOPICS = ['orders/create', 'customers/create']
  WEBHOOK_ADDRESS = 'https://app.onlineventurechallenge.com/shopify_webhooks'

  attr_reader :shop

  def initialize(shop)
    @shop = shop
  end

  def synchronize
    log("synchronizing shop ##{@shop.id}")
    synchronize_orders
    synchronize_customers
    synchronize_webhooks
    synchronize_products
  end

  # Synchronize customers
  #
  # Fetches customers since most recently created customer.
  # Creates any missing customers.
  #
  # NOTE: This may be run concurrently, so make sure to handle customer
  # creation conflicts in a threadsafe manner.
  #
  def synchronize_customers
    fetch_shopify_customers.each do |shp_cus|
      create_customer(shp_cus)
    end
  end

  # Synchronize orders
  #
  # Fetches all orders.
  # Creates any missing orders.
  #   If there is a referring_site
  #     Creates a referral.
  #     Sets the order’s referral.
  # Updates the financial status on existing orders in case there
  # was a refund, e.g.
  #
  # NOTE: This may be run concurrently, so make sure to handle order
  # creation conflicts in a threadsafe manner.
  #
  def synchronize_orders
    fetch_shopify_orders.each do |shp_order|
      process_order(shp_order)
    end
  end

  # Synchronize webhooks
  #
  # Create any shopify webhooks that are missing for this shop.
  #
  def synchronize_webhooks
    webhooks = api.fetch_webhooks

    WEBHOOK_TOPICS.each do |topic|
      create_webhook(topic) if webhooks.none? { |wh| valid_webhook?(wh, topic) }
    end

    # Mark shop's webhooks as checked.
    # NOTE: This field is not currently used.
    shop.touch(:webhooks_last_checked_at)
  end

  # Synchronize products
  #
  # Update the shops product data, which is simply derived from its
  # line_items.
  #
  def synchronize_products
    # NOTE: This won't delete products if we resynchronize and they
    # are no longer in the line items. I don't see why that would
    # ever happen, though.
    shop.products.each do |product|
      product.update(quantity: 0, total_revenue: 0)
    end

    shop.line_items.paid.each do |line_item|
      if product = shop.products.find_by(uid: line_item.product_uid)
        product.update!(
          quantity: product.quantity + line_item.quantity,
          total_revenue: product.total_revenue + line_item.revenue
        )
      else
        shop.products.create!(
          uid: line_item.product_uid,
          name: line_item.title,
          quantity: line_item.quantity,
          total_revenue: line_item.revenue
        )
      end
    end
  end

  def process_order(shopify_order)
    if order = shop.orders.find_by(uid: shopify_order.uid)
      # Update an existing order

      # We want to make sure that the financial status stays up-to-date
      # in case refunds occured, e.g.
      order.update!(financial_status: shopify_order.financial_status)


      if order.referral
        order.referral.update!(url: shopify_order.referring_site)
      end

      if !order.referral.present? && shopify_order.referring_site.present?
        Referral.create!(order: order, url: shopify_order.referring_site)
      end

    else
      # Create a new order

      o = shopify_order

      ActiveRecord::Base.transaction do
        order = shop.orders.create!( uid:              o.uid,
                                     placed_at:        o.created_at,
                                     customer_uid:     o.customer_uid,
                                     subtotal_price:   o.subtotal_price,
                                     total_tax:        o.total_tax,
                                     total_discounts:  o.total_discounts,
                                     total_price:      o.total_price,
                                     financial_status: o.financial_status )

        if o.referring_site.present?
          Referral.create!(order: order, url: o.referring_site)
        end

        o.line_items.each do |line_item_params|
          order.line_items.create!(line_item_params)
        end
      end

    end

  rescue ActiveRecord::RecordNotUnique => e
    # Since this may be run in parallel, it's still possible to attempt to
    # create two orders at the same time.
    Rails.logger.info("Conflict when creating order #{o.uid}.")
  end

  private

    def create_customer(shopify_customer)
      c = shopify_customer
      shop.customers.create!( uid: c.uid,
                              email: c.email,
                              acquired_at: c.created_at )
    rescue ActiveRecord::RecordNotUnique => e
      Rails.logger.info("Skipping customer #{c.uid} because it already exists.")
    end

    def fetch_shopify_customers
      if last_customer = shop.last_acquired_customer
        api.fetch_customers(since_id: last_customer.uid)
      else
        api.fetch_customers
      end
    end

    def fetch_shopify_orders
      api.fetch_all_orders
    end

    def valid_webhook?(webhook, topic)
      webhook.topic == topic && webhook.address == WEBHOOK_ADDRESS
    end

    def create_webhook(topic)
      api.post_webhook(topic, WEBHOOK_ADDRESS)
    rescue StandardError => e
      # This can fail when a shop is not setup properly.
      # monitor when that happens.
      ReportError.call(e.message)
    end

    def api
      @api ||= Shopify::Shop.new(shop.shopify_uid, shop.shopify_token)
    end

    def log(msg)
      Rails.logger.info("ShopSynchronizer: #{msg}")
    end

end
