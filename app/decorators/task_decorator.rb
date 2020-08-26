class TaskDecorator < Draper::Decorator

  delegate_all

  def badge_path
    "badges/#{code}.png"
  end

  def submission_name
    case code
    when 'pr_genius' then 'article'
    when 'charitably_savvy' then 'charity endorsement'
    when 'blogger' then 'blog post'
    end
  end

  def path
    h.tasks_path(anchor: "task-#{id}")
  end

  def modal_id
    "task-modal-#{id}"
  end

  def tooltip
    "<strong>#{name}</strong>: #{points} points".html_safe
  end

  def learning_resources
    object.learning_resources
  end

end
