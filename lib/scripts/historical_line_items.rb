# Get historical line items for already synchronized orders
#
# We only need to do this for teams in active, live competitions.
#

def update_line_items(shop)
  api = Shopify::Shop.new(shop.shopify_uid, shop.shopify_token)

  api.fetch_orders.each do |shopify_order|
    if order = Order.find_by(uid: shopify_order.uid)
      shopify_order.line_items.each do |line_item_params|
        order.line_items.create!(line_item_params)
      end
    end
  end
end

Competition.active.live.each do |competition|
  competition.teams.with_shop.each do |team|
    update_line_items(team.shop)
  end
end