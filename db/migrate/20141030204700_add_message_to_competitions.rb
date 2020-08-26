class AddMessageToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :message, :text
  end
end
