module Youtube
class Video

  EXAMPLE_URL = 'http://youtu.be/7N8b3NZSJoY'

  SHARE_STYLE_REGEX = %r(/.*youtu\.be/(.+))
  EMBED_STYLE_REGEX = %r(//www\.youtube\.com/embed/(.+))

  class InvalidUrlError < StandardError; end

  attr_accessor :uid

  def initialize(uid)
    @uid = uid
  end

  def embed_url
    "//www.youtube.com/embed/#{uid}"
  end

  def self.parse(url)
    raise InvalidUrlError unless valid?(url)

    uid = if share_style?(url)
      url.match(SHARE_STYLE_REGEX)[1]
    else
      url.match(EMBED_STYLE_REGEX)[1]
    end

    new(uid)
  end

  def self.valid?(url)
    share_style?(url) || embed_style?(url)
  end

  def self.share_style?(url)
    url.match(SHARE_STYLE_REGEX)
  end

  def self.embed_style?(url)
    url.match(EMBED_STYLE_REGEX)
  end

end
end