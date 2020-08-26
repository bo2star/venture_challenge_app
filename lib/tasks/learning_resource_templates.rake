namespace :learning_resource_templates do

  task :export do
    data = LearningResource.templates.map { |lr|
      {
        title: lr.title,
        body: lr.body,
        video_url: lr.video_url,
        order: lr.order,
        tasks: lr.tasks.map { |t| { title: t.title, order: t.order } },
        questions: lr.questions.map { |q| { title: q.title, order: q.order } }
      }
    }

    puts data.to_yaml
  end

end