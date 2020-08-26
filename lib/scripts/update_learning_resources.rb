# Apply any new learning resources to existing instructors.

# NOTE: These changes will be seen by teams created after
# this script is run, but not by those created before,
# regardless of the competition.

# WARNING: This script is a hack. You should think about its impact
# before running it.

def update_learning_resources(dry_run:)

  templates = LearningResource.published.templates

  Instructor.where(is_seeded: false).each do |instructor|
    puts "Updating instructor ##{instructor.id}"

    lrs = instructor.learning_resources

    templates.each do |template|
      if lr = lrs.find_by(title: template.title)
        if lr.updated_at - lr.created_at > 10 # seconds
          # The instructor edited this learning resource.
          # Do nothing.
          puts "\tSkipped template ##{template.id} because the instructor has edited it."
        else
          # The instructor has never edited this learning resource.
          # Replace it with the new one.

          unless dry_run
            # Soft-delete and unpublish old learning resource.
            lr.update!(is_deleted: true, is_published: false)

            # Duplicate the new one for them.
            template.duplicate_for(instructor)
          end

          puts "\tUpdated instructor's version of template ##{template.id}."
        end
      else
        # They don't have this learning resource.
        # Duplicate it for them.
        unless dry_run
          template.duplicate_for(instructor)
        end

        puts "\tCreated new learning resource from template ##{template.id}"
      end
    end
  end

end

update_learning_resources(dry_run: true)