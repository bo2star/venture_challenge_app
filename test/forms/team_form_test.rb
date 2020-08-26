require_relative '../test_helper'

class TeamFormTest < ActiveSupport::TestCase

  def setup
    @comp = competitions(:killer_league)
  end

  test 'requires a name' do
    assert TeamForm.new(@comp, name: 'Some name').valid?
    assert TeamForm.new(@comp, name: nil).invalid?
  end

  test 'requires name to be unique' do
    assert TeamForm.new(@comp, name: 'Bobs Team').invalid?
  end

end