class StudentDecorator < Draper::Decorator

  delegate_all

  def avatar_url
    object.avatar_url || h.asset_path('avatar_missing.png')
  end

  def team_revenue
    object.team.students.count * 25.0
  end
end