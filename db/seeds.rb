raise "Seeds are destructive. Only run them in development." unless Rails.env.development?

def create_learning_resource_template(data)
  lr = LearningResource.create!( title: data[:title],
                                 body: data[:body],
                                 video_url: data[:video_url],
                                 order: data[:order],
                                 is_published: true,
                                 is_template: true )

  data[:tasks].each { |d| create_task(lr, d) }

  data[:questions].each { |d| create_question(lr, d) }

end

def create_task(lr, data)
  lr.tasks.create!(title: data[:title], order: data[:order])
end

def create_question(lr, data)
  lr.questions.create!(title: data[:title], order: data[:order])
end

ActiveRecord::Base.transaction do
  LearningResource.templates.destroy_all

  data = YAML.load_file(Rails.root.join('config', 'learning_resource_template_seeds.yml'))

  data.each { |d| create_learning_resource_template(d) }
end