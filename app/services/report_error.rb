class ReportError
  extend Service

  def initialize(msg)
    @msg = msg
  end

  def call
    Rails.logger.error(@msg)
    NewRelic::Agent.notice_error(@msg)
  end

end