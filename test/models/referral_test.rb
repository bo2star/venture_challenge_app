require 'test_helper'

class ReferralTest < ActiveSupport::TestCase

  test 'domain' do
    assert_domain 'r.search.yahoo.com', 'http://r.search.yahoo.com/_ylt=AwrBTv0wsfpTbVAA'
    assert_domain 'www.google.com', 'http://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&ved=0CB4QFjAA&url=http%3A%2'
    assert_domain 'marinersinnonline.myshopify.com', 'http://marinersinnonline.myshopify.com/'
  end

  def assert_domain(domain, url)
    assert_equal domain, Referral.new(url: url).domain
  end

end
