require 'test_helper'

class LearningResourceTest < ActiveSupport::TestCase

  test 'requires youtube video format' do
    lr = learning_resources(:unpublished)

    assert lr.valid?

    lr.video_url = 'http://notyoutubevideo.com'
    assert lr.invalid?

    # Embed-style
    lr.video_url = '//www.youtube.com/embed/oTuEvnfgQcY'
    assert lr.valid?

    # Share-style
    lr.video_url = 'http://youtu.be/oTuEvnfgQcY'
    assert lr.valid?

    # Blank
    lr.video_url = ''
    assert lr.valid?
  end

  test 'generates a video embed url' do
    lr = learning_resources(:unpublished)

    lr.video_url = 'http://youtu.be/oTuEvnfgQcY'
    assert_equal '//www.youtube.com/embed/oTuEvnfgQcY', lr.video_embed_url

    lr.video_url = ''
    assert_equal nil, lr.video_embed_url
  end

  test 'publish and unpublish' do
    lr = learning_resources(:unpublished)
    assert_not lr.is_published

    lr.publish

    assert lr.reload.is_published

    lr.unpublish

    assert_not lr.reload.is_published
  end

  test 'getting published' do
    assert_equal 2, LearningResource.published.size
    assert_equal learning_resources(:published), LearningResource.published.last
  end

  test 'getting templates' do
    t = learning_resources(:template)

    templates = LearningResource.templates

    assert_equal 1, templates.size
    assert_equal t, templates.first
  end

  test 'duplicate for an instructor' do
    template = learning_resources(:template)
    inst = instructors(:john)

    assert_equal 0, inst.learning_resources.size

    dup = template.duplicate_for(inst)

    assert_equal LearningResource, dup.class
    assert_equal 1, inst.reload.learning_resources.size
    assert_not dup.is_template
    assert dup.is_published
    assert_equal 1, dup.questions.size
    assert_equal 1, dup.tasks.size
  end

  test 'duplicate for a team' do
    resource = learning_resources(:template)
    team = teams(:bobs_team)

    assert_equal 2, team.learning_resources.size

    dup = resource.duplicate_for_team(team)

    assert_equal TeamLearningResource, dup.class
    assert_equal 3, team.reload.learning_resources.size
    assert_equal 1, dup.questions.size
    assert_equal 1, dup.tasks.size
  end

end
