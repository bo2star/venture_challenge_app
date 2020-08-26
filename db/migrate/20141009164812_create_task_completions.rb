class CreateTaskCompletions < ActiveRecord::Migration
  def change
    enable_extension 'hstore'

    create_table :task_completions do |t|
      t.references :task, index: true
      t.references :team, index: true
      t.hstore :data

      t.timestamps
    end
  end
end
