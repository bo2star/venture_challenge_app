class EnsureCompetitionTokenIsUnique < ActiveRecord::Migration
  def change
    add_index :competitions, :token, unique: true
  end
end
