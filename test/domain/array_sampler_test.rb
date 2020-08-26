require 'test_helper'

class ArraySamplerTest < ActiveSupport::TestCase

  test 'least used color' do
    s = ArraySampler.new([1, 2])

    assert_equal 1, s.least_used([2])
    assert_equal 2, s.least_used([1])
    assert_equal 2, s.least_used([1, 2, 1])
    assert_equal 1, s.least_used([1, 2, 2])
  end

end
