class ShopifyWebhooksController < ApplicationController

  protect_from_forgery with: :null_session

  # Catch-all for any shopify webhook.
  #   We don't care about the request contents, instead we simply
  #   enqueue a job to synchronize the relevant team's data.
  #
  def create
    # Shopify passes the shop domain (aka uid) as an environment variable,
    # not as part of the request body.
    shop_uid = request.env['HTTP_X_SHOPIFY_SHOP_DOMAIN']

    Rails.logger.info("Shopify webook received for shop '#{shop_uid}'")

    shop = Shop.find_by(shopify_uid: shop_uid)

    if shop
      SynchronizeTeamJob.new.async.perform(shop.team.id)
    else
      Rails.logger.info("Shop not found '#{shop_uid}'")
    end

  rescue StandardError => e
    # Rescue any error so that we always respond with 200, otherwise Shopify will disable the webhook.
    # Still log and report an error to newrelic, though, so that we know about it.
    ReportError.call("Error processing shopify webhook: #{e.message}")
  ensure
    head :ok
  end

end