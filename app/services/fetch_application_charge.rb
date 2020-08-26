class FetchApplicationCharge < Struct.new(:uid, :token, :charge_id)
  extend Service

  def call
    Shopify::Shop.new(uid, token).fetch_application_charge(charge_id)
  end

end