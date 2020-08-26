class TaskType

  class InvalidCodeError < StandardError; end

  CODES = {
    referral:          %w(twitter facebook pinterest instagram sem),
    revenue:           %w(lemonade_stand small_business medium_business enterprise multi_national),
    launch:            %w(launch),
    url_submission:    %w(pr_genius charitably_savvy blogger),
    text_submission:   %w(analytics),
    learning_resource: %w(learning_resource)
  }

  attr_reader :code

  def initialize(code)
    @code = code
  end

  def self.codes_for(type)
    CODES[type]
  end

  def type
    @type ||= compute_type
  end

  def referral?
    type == :referral
  end

  def revenue?
    type == :revenue
  end

  def launch?
    type == :launch
  end

  def url_submission?
    type == :url_submission
  end

  def text_submission?
    type == :text_submission
  end

  def learning_resource?
    type == :learning_resource
  end

  private

    def compute_type
      CODES.each do |type, codes|
        return type if codes.include?(code)
      end

      raise InvalidCodeError, "Invalid code: #{code}"
    end

end