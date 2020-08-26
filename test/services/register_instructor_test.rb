require 'test_helper'

class RegisterInstructorTest < ActiveSupport::TestCase

  test 'creating an instructor with appropriate attributes' do
    inst = RegisterInstructor.call( name: 'Mitch',
                                    email: 'mitch@mail.com',
                                    linkedin_uid: '123',
                                    linkedin_token: '456' )

    assert inst.persisted?
    assert_equal '123', inst.linkedin_uid
    assert_equal '456', inst.linkedin_token
    assert_equal 'Mitch', inst.name
    assert_equal 'mitch@mail.com', inst.email
  end


  test 'creates learning resources from templates' do
    inst = RegisterInstructor.call(name: 'Mitch', email: 'mitch@mail.com')

    assert_equal 1, inst.learning_resources.size
    assert_equal 'Template 1', inst.learning_resources.first.title
  end

end
