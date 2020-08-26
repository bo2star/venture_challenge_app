require_relative '../../test_helper'

class Youtube::VideoTest < ActiveSupport::TestCase

  test 'recognizes share-style URLs' do
    url = 'http://youtu.be/oTuEvnfgQcY'

    assert Youtube::Video.share_style?(url), 'is share style'
    assert_not Youtube::Video.embed_style?(url), 'is not embed style'
  end

  test 'recognizes embed-style URLs' do
    url = '//www.youtube.com/embed/oTuEvnfgQcY'

    assert Youtube::Video.embed_style?(url), 'is embed style'
    assert_not Youtube::Video.share_style?(url), 'is not share style'
  end

  test 'valid if share-style or embed-style' do
    assert Youtube::Video.valid?('http://youtu.be/oTuEvnfgQcY')
    assert Youtube::Video.valid?('//www.youtube.com/embed/oTuEvnfgQcY')

    assert_not Youtube::Video.valid?('http://notyoutube.com')
  end

  test 'parse urls' do
    assert_equal 'oTuEvnfgQcY', Youtube::Video.parse('http://youtu.be/oTuEvnfgQcY').uid
    assert_equal 'oTuEvnfgQcY', Youtube::Video.parse('http://youtu.be/oTuEvnfgQcY').uid
  end

  test 'generate an embed_url' do
    assert_equal '//www.youtube.com/embed/oTuEvnfgQcY', Youtube::Video.new('oTuEvnfgQcY').embed_url
  end

end