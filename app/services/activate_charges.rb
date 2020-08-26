# ActivateCharges
#
# Convenience service to activate all unactivated charges.
#
class ActivateCharges
  extend Service

  def call
    log("activating charges")

    Charge.unactivated.each do |charge|
      log("Activating charge ##{charge.id}")
      ActivateCharge.call(charge)
    end
  end

  private

    def log(msg)
      Rails.logger.info("ActivateCharges: #{msg}")
    end

end