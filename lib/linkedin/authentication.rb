module Linkedin
class Authentication

  def initialize(linkedin_hash)
    @data = linkedin_hash
  end

  def uid
    @data['uid']
  end

  def token
    @data['credentials']['token']
  end

  def name
    first = info['first_name']
    last = info['last_name']
    "#{first} #{last}"
  end

  def phone
    # Most people probably don't have their phone number set
    # in linkedin. Do we need it?
  end

  def email
    info['email']
  end

  def image
    info['picture_url']
  end

  private

    def info
      @data['info']
    end

end
end