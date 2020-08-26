# == Schema Information
#
# Table name: learning_resources
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  body          :text
#  video_url     :string(255)
#  instructor_id :integer          indexed
#  order         :integer          default("0")
#  is_template   :boolean          default("false")
#  created_at    :datetime
#  updated_at    :datetime
#  is_published  :boolean          default("false")
#  description   :text
#  is_deleted    :boolean          default("false")
#
# Indexes
#
#  index_learning_resources_on_instructor_id  (instructor_id)
#

class LearningResource < ActiveRecord::Base

  include Sortable

  belongs_to :instructor

  has_many :questions, class_name: 'LearningResourceQuestion', dependent: :destroy
  has_many :tasks, class_name: 'LearningResourceTask', dependent: :destroy

  validates :title,
            presence: true

  validates :body,
            presence: true

  validate :require_valid_youtube_video_url

  scope :templates, -> { where(is_template: true) }

  scope :published, -> { where(is_published: true) }

  scope :non_deleted, -> { where(is_deleted: false) }

  def publish
    update!(is_published: true)
  end

  def unpublish
    update!(is_published: false)
  end

  def video_embed_url
    video_url.presence && Youtube::Video.parse(video_url).embed_url
  end

  def duplicate_for(instructor)
    dup = LearningResource.create!( instructor: instructor,
                                    title: title,
                                    body: body,
                                    video_url: video_url,
                                    is_published: true,
                                    order: order )
    # Duplicate questions.
    questions.each do |q|
      dup.questions.create!( title: q.title,
                             order: q.order )
    end

    # Duplicate tasks.
    tasks.each do |t|
      dup.tasks.create!( title: t.title,
                         order: t.order )
    end

    dup
  end

  def duplicate_for_team(team)
    dup = TeamLearningResource.create!(
      team: team,
      title: title,
      body: body,
      video_url: video_url,
      order: order
    )

    # Duplicate questions.
    questions.each do |q|
      dup.questions.create!( title: q.title,
                             order: q.order )
    end

    # Duplicate tasks.
    tasks.each do |t|
      dup.tasks.create!( title: t.title,
                         order: t.order )
    end

    dup
  end

  protected

    # Requires the url be a valid youtube url.
    #
    def require_valid_youtube_video_url
      return if video_url.blank?
      return if Youtube::Video.valid?(video_url)

      errors.add(:video_url, 'must be a youtube video URL')
    end

end
