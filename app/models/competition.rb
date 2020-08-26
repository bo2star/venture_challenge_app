# == Schema Information
#
# Table name: competitions
#
#  id            :integer          not null, primary key
#  instructor_id :integer          indexed
#  name          :string(255)
#  start_date    :datetime
#  end_date      :datetime
#  welcome_note  :text
#  token         :string(255)      indexed
#  created_at    :datetime
#  updated_at    :datetime
#  message       :text
#  is_seeded     :boolean          default("false")
#
# Indexes
#
#  index_competitions_on_instructor_id  (instructor_id)
#  index_competitions_on_token          (token) UNIQUE
#

class Competition < ActiveRecord::Base

  belongs_to :instructor
  has_many :teams, dependent: :destroy
  has_many :students, dependent: :destroy

  before_create :set_token

  validates :name,
            presence: true

  validates :start_date,
            presence: true,
            date: true

  validates :end_date,
            presence: true,
            date: { after: :start_date }

  scope :active, -> { where('start_date <= ?', Date.current).where('end_date >= ?', Date.current) }
  scope :live, -> { where(is_seeded: false) }

  def teamless_students
    students.where(team: nil)
  end

  # Date range between the start date and today, or the end date
  # if the competition has ended.
  def elapsed_date_range
    last = ended? ? end_date : Date.today
    DateRange.new(start_date, last + 1.day)
  end

  def learning_resources
    instructor.learning_resources.published
  end

  def started?
    days_until_start == 0
  end

  def ended?
    days_remaining == 0
  end

  def active?
    !ended?
  end

  def days_until_start
    [(start_date.to_date - Date.today).to_i, 0].max
  end

  def days_remaining
    [(end_date.to_date - Date.today).to_i, 0].max
  end

  def teams_by_points
    teams.sort_by { |team| -team.cached_total_points }
  end

  def leader
    teams_by_points.first
  end

  def leader_points
    leader.cached_total_points
  end

  def team_rank(team)
    teams_by_points.find_index(team) + 1
  end

  def seeded?
    !!is_seeded
  end

  protected

    def set_token
      self.token = generate_token
    end

  private

    def generate_token
      loop do
        t = SecureRandom.urlsafe_base64(4)
        break t unless Competition.exists?(token: t)
      end
    end

end
