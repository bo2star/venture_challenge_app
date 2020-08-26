require 'test_helper'

class ShopRequestTest < ActiveSupport::TestCase

  def setup
    @req = shop_requests(:one)
  end

  test 'pending by default' do
    assert @req.is_pending
  end

  test 'complete' do
    @req.complete
    assert_not @req.reload.is_pending
  end

end