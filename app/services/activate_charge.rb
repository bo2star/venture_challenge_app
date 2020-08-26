# ActivateCharge
#
# We activate shopify application charges in the background so as to not inconvenience the user.
# An unactivated Charge is a placeholder for an accepted application charge that has not been activated yet.
# This service activates an unactivated Charge by posting to shopify.
#
class ActivateCharge
  extend Service

  def initialize(charge)
    @charge = charge
  end

  def call
    api = Shopify::Shop.new(@charge.shop.shopify_uid, @charge.shop.shopify_token)
    api.activate_application_charge(@charge.uid)
    @charge.activate
  end

end