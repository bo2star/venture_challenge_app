require_relative '../../test_helper'

class Shopify::WebhookTest < ActiveSupport::TestCase

  WEBHOOK_JSON = <<-JSON
{
  "address": "http://apple.com",
  "created_at": "2014-09-24T16:09:58-04:00",
  "fields": [

  ],
  "format": "xml",
  "id": 4759306,
  "metafield_namespaces": [

  ],
  "topic": "orders/create",
  "updated_at": "2014-09-24T16:09:58-04:00"
}
JSON

  test "creating from shopify hash" do
    webhook = Shopify::Webhook.new( JSON.parse(WEBHOOK_JSON) )

    assert_equal 'orders/create', webhook.topic
    assert_equal 'http://apple.com', webhook.address
  end
end
