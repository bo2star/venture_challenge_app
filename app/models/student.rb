# == Schema Information
#
# Table name: students
#
#  id              :integer          not null, primary key
#  competition_id  :integer          indexed
#  team_id         :integer          indexed
#  name            :string(255)
#  email           :string(255)
#  phone           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  linkedin_uid    :string(255)      indexed
#  linkedin_token  :text
#  avatar_url      :string(255)
#  password_digest :string(255)
#
# Indexes
#
#  index_students_on_competition_id  (competition_id)
#  index_students_on_linkedin_uid    (linkedin_uid) UNIQUE
#  index_students_on_team_id         (team_id)
#

class Student < ActiveRecord::Base

  has_secure_password validations: false

  belongs_to :competition
  belongs_to :team

  def join_competition(competition)
    update!(competition: competition)
  end

  def join_team(team)
    update!(team: team)
  end

  def leave_team
    update!(team: nil)
  end

  def has_team?
    !!team
  end

  def first_name
    name && name.split(' ').first
  end

  def linked_in?
    !!linkedin_uid
  end

end
