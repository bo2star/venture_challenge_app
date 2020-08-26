Rails.application.config.middleware.use OmniAuth::Builder do

  provider :linkedin, ENV['LINKEDIN_KEY'], ENV['LINKEDIN_SECRET']

  shopify_setup = lambda { |env|
    params = Rack::Utils.parse_query(env['QUERY_STRING'])
    env['omniauth.strategy'].options[:client_options][:site] = "https://#{params['shop']}"
  }

  provider :shopify, ENV['SHOPIFY_KEY'], ENV['SHOPIFY_SECRET'],
           # Request to read orders and customers.
           scope: 'read_orders,read_customers',
           # Setup the shopify site from the "shop" url param.
           setup: shopify_setup

  OmniAuth.config.on_failure = Proc.new { |env|
    OmniAuth::FailureEndpoint.new(env).redirect_to_failure
  }
end