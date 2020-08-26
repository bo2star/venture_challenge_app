class CreateTeamLearningResources < ActiveRecord::Migration
  def change
    create_table :team_learning_resources do |t|
      t.references :team, index: true
      t.references :learning_resource, index: true
      t.boolean :is_complete, default: true
      t.integer :order, default: 0
      t.string :title
      t.text :body
      t.string :video_url

      t.timestamps
    end

    drop_table :learning_resource_responses
  end
end
