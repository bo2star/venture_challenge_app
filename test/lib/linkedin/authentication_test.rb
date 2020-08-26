require_relative '../../test_helper'

class Linkedin::AuthenticationTest < ActiveSupport::TestCase

  HASH = {"provider"=>"linkedin", "uid"=>"Qjxcm3v6vv", "info"=>{"name"=>"Mitch Crowe", "email"=>"crowe.mitch@gmail.com", "nickname"=>"Mitch Crowe", "first_name"=>"Mitch", "last_name"=>"Crowe", "location"=>{"country"=>{"code"=>"ca"}, "name"=>"Vancouver, Canada Area"}, "description"=>"Freelance Web Developer; Start-up enthusiast; Entrepreneur", "image"=>"https://media.licdn.com/mpr/mprx/0_mLnj-0s2x996RrBKuFrC-gZ20KtXRPBKhTCC-gZlhvQzXc8rGiQAyj2xAO-VZNny76NijV6GAbkE", "urls"=>{"public_profile"=>"https://www.linkedin.com/pub/mitch-crowe/27/999/a60"}}, "credentials"=>{"token"=>"AQW6-BGjoXBZ87KZj_fixliCWB2MBFgpWhhRv985KnOAxZOj735i6ls3PIaW8KAb2QhFPwk4XcrmbkxaymOTYw-anRFaRMZRW_ygQFYbDFCxFUJ_LfxtudhtoKqtxB3FPikaWOUAVCsGAc7d-h8OsMUHutAsxa32M6gY0OtxqKJlD9lVaQ0", "expires_at"=>1416281311, "expires"=>true}, "extra"=>{"raw_info"=>{"emailAddress"=>"crowe.mitch@gmail.com", "firstName"=>"Mitch", "headline"=>"Freelance Web Developer; Start-up enthusiast; Entrepreneur", "id"=>"Qjxcm3v6vv", "industry"=>"Computer Software", "lastName"=>"Crowe", "location"=>{"country"=>{"code"=>"ca"}, "name"=>"Vancouver, Canada Area"}, "pictureUrl"=>"https://media.licdn.com/mpr/mprx/0_mLnj-0s2x996RrBKuFrC-gZ20KtXRPBKhTCC-gZlhvQzXc8rGiQAyj2xAO-VZNny76NijV6GAbkE", "publicProfileUrl"=>"https://www.linkedin.com/pub/mitch-crowe/27/999/a60"}}}
  TOKEN = 'AQW6-BGjoXBZ87KZj_fixliCWB2MBFgpWhhRv985KnOAxZOj735i6ls3PIaW8KAb2QhFPwk4XcrmbkxaymOTYw-anRFaRMZRW_ygQFYbDFCxFUJ_LfxtudhtoKqtxB3FPikaWOUAVCsGAc7d-h8OsMUHutAsxa32M6gY0OtxqKJlD9lVaQ0'
  IMAGE = 'https://media.licdn.com/mpr/mprx/0_mLnj-0s2x996RrBKuFrC-gZ20KtXRPBKhTCC-gZlhvQzXc8rGiQAyj2xAO-VZNny76NijV6GAbkE'

  test "creating from omniauth hash" do
    authentication = Linkedin::Authentication.new(HASH)

    assert_equal 'Qjxcm3v6vv', authentication.uid
    assert_equal 'Mitch Crowe', authentication.name
    assert_equal 'crowe.mitch@gmail.com', authentication.email
    assert_equal TOKEN, authentication.token
    assert_equal IMAGE, authentication.image
  end
end
