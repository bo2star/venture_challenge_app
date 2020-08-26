# == Schema Information
#
# Table name: instructors
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  phone           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  linkedin_uid    :string(255)      indexed
#  linkedin_token  :string(255)
#  avatar_url      :string(255)
#  is_seeded       :boolean          default("false")
#  password_digest :string(255)
#
# Indexes
#
#  index_instructors_on_linkedin_uid  (linkedin_uid) UNIQUE
#

class Instructor < ActiveRecord::Base

  has_secure_password validations: false

  has_many :competitions, dependent: :destroy
  has_many :learning_resources, dependent: :destroy

  def seeded?
    !!is_seeded
  end

  def linked_in?
    !!linkedin_uid
  end

end
