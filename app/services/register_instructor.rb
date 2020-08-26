# RegisterInstructor
#
# - Creates an instructor with the given attributes.
# - Duplicates all of the published template learning resources for the instructor to use.
#
class RegisterInstructor
  extend Service

  def initialize(attributes)
    @attributes = attributes
  end

  def call
    instructor = nil

    ActiveRecord::Base.transaction do
      instructor = Instructor.create!(@attributes)

      LearningResource.published.templates.each do |lr|
        lr.duplicate_for(instructor)
      end
    end

    # This is outside the transaction because it is slow running,
    # and not mission critical.
    SeedCompetitionJob.new.async.perform(instructor.id)

    instructor
  end

end