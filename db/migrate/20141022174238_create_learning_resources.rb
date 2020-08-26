class CreateLearningResources < ActiveRecord::Migration
  def change
    create_table :learning_resources do |t|
      t.string :title
      t.text :body
      t.string :video_url
      t.references :instructor, index: true
      t.integer :order, default: 0
      t.boolean :is_template, default: false

      t.timestamps
    end
  end
end
