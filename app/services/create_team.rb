# CreateTeam
#
# - Creates a team with the given name, for the given competition.
# - Assigns a color to the team that is used the least often in its competition.
# - Creates Team Learning Resources for each learning resource in the competition (the instructor's published LRs).
# - Creates a team Task for each learning resource prioritized in the order given by the instructor.
# - Creates all the default Tasks for the team.
# - Prioritizes Learning Resource tasks ahead of defaul tasks.
#
class CreateTeam

  COLORS = %w(#D24D57 #F22613 #D91E18 #96281B #EF4836 #D64541 #C0392B #CF000F #E74C3C #DB0A5B #F64747 #F1A9A0 #D2527F #E08283 #F62459 #E26A6A #DCC6E0 #663399 #674172 #AEA8D3 #913D88 #9A12B3 #BF55EC #BE90D4 #8E44AD #9B59B6 #446CB3 #E4F1FE #4183D7 #59ABE3 #81CFE0 #52B3D9 #C5EFF7 #22A7F0 #3498DB #2C3E50 #19B5FE #336E7B #22313F #6BB9F0 #1E8BC3 #3A539B #34495E #67809F #2574A9 #1F3A93 #89C4F4 #4B77BE #5C97BF #4ECDC4 #A2DED0 #87D37C #90C695 #26A65B #03C9A9 #68C3A3 #65C6BB #1BBC9B #1BA39C #66CC99 #36D7B7 #C8F7C5 #86E2D5 #2ECC71 #16a085 #3FC380 #019875 #03A678 #4DAF7C #2ABB9B #00B16A #1E824C #049372 #26C281 #FDE3A7 #F89406 #EB9532 #E87E04 #F4B350 #F2784B #EB974E #F5AB35 #D35400 #F39C12 #F9690E #F9BF3B #F27935 #E67E22 #ececec #6C7A89 #D2D7D3 #EEEEEE #BDC3C7 #ECF0F1 #95A5A6 #DADFE1 #ABB7B7 #F2F1EF #BFBFBF)

  extend Service

  def initialize(competition, name)
    @competition, @name = competition, name
    @priority = 0
  end

  def call
    ActiveRecord::Base.transaction do
      team = Team.create!( competition: @competition,
                           name:        @name,
                           color:       choose_color )

      # Duplicate learning resources
      @competition.learning_resources.each do |lr|
        lr.duplicate_for_team(team)
      end

      # Create tasks for learning resources
      team.learning_resources.sorted.each_with_index do |lr|
        task = push_task( team, learning_resource_task_data(lr) )
        lr.update!(task: task)
      end

      # Create base tasks
      default_task_data.each_with_index do |data, i|
        push_task(team, data)
      end

      team
    end
  end

  private

    def push_task(team, data)
      task = team.tasks.create!(data.merge(priority: @priority))
      @priority += 1
      task
    end

    def learning_resource_task_data(lr)
      {
        name: lr.title,
        code: 'learning_resource',
        description: 'Complete this learning resource to earn points for your team.',
        points: 25
      }
    end

    def choose_color
      used_colors = @competition.teams.pluck(:color)
      ArraySampler.new(COLORS).least_used(used_colors)
    end

    def default_task_data
      YAML.load_file(Rails.root.join('config', 'team_tasks.yml'))
    end
end
