require 'shopify/customer'
require 'shopify/order'
require 'shopify/webhook'
require 'shopify/application_charge'

class Shopify::Shop

  class RequestFailed < StandardError; end

  def initialize(uid, token)
    @uid = uid
    @token = token
  end

  def fetch_customers(*args)
    json = fetch_collection('customers', *args)
    customers = json['customers'] || []
    customers.map { |json| Shopify::Customer.new(json) }
  end

  def fetch_orders(*args)
    json = fetch_collection('orders', *args)
    orders = json['orders'] || []
    orders.map { |json| Shopify::Order.new(json) }
  end

  def fetch_all_orders
    # Shopify has an api limit of 250 orders in a call.
    # No team has reached that yet, but to be safe we will
    # look across multiple pages and ensure we get all orders
    # for this shop.
    limit = 250
    page = 1
    all_orders = []

    while true
      page_orders = fetch_orders(page: page, limit: limit)
      all_orders += page_orders
      break if page_orders.size < limit
      page += 1
    end

    all_orders
  end

  def fetch_webhooks(*args)
    json = fetch_collection('webhooks', *args)
    webhooks = json['webhooks'] || []
    webhooks.map { |json| Shopify::Webhook.new(json) }
  end

  def post_webhook(topic, address)
    body = {
      webhook: {
        topic: topic,
        address: address,
        format: 'json'
      }
    }

    res = post_resource('webhooks', body)

    unless res.code == 201
      Rails.logger.error("Shopify::Shop#post_webhook failed #{res.code} - #{res.message}: #{res.parsed_response}")
      raise RequestFailed, "#{res.message}"
    end
  end

  def fetch_application_charge(uid)
    json = fetch_resource('application_charges', uid)
    Shopify::ApplicationCharge.new(json['application_charge'])
  end

  def post_application_charge(name:, price:, return_url:, test: false)
    body = {
      application_charge: {
        name: name,
        price: price,
        return_url: return_url,
        test: test
      }
    }

    res = post_resource('application_charges', body)

    unless res.code == 201
      Rails.logger.error("Shopify::Shop#post_application_charge failed #{res.code} - #{res.message}: #{res.parsed_response}")
      raise RequestFailed, "#{res.message}"
    end

    Shopify::ApplicationCharge.new(res.parsed_response['application_charge'])
  end

  def activate_application_charge(uid)
    res = HTTParty.post(base_url + "application_charges/#{uid}/activate.json", headers: headers)

    unless res.code == 200
      Rails.logger.error("Shopify::Shop#activate_application_charge failed #{res.code} - #{res.message}: #{res.parsed_response}")
      raise RequestFailed, "#{res.message}"
    end
  end

  private

    def fetch_resource(resource_name, uid)
      url = base_url + resource_name + "/#{uid}.json"
      HTTParty.get(url, headers: headers).parsed_response
    end

    def fetch_collection(resource_name, limit: 50, page: 1, since_id: nil)
      query = {
        limit: limit,
        page: page
      }
      query[:since_id] = since_id if since_id

      url = collection_url(resource_name)

      HTTParty.get(url, query: query, headers: headers).parsed_response
    end

    def post_resource(resource_name, body)
      url = collection_url(resource_name)

      HTTParty.post(url, body: body, headers: headers)
    end

    def base_url
      "https://#{@uid}/admin/"
    end

    def collection_url(resource_name)
      collectionUrl = base_url + resource_name + '.json'
      resource_name == 'orders' ? collectionUrl << '?status=any' : collectionUrl
    end

    def headers
      { 'X-Shopify-Access-Token' => @token }
    end

end
