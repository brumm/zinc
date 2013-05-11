class AddEndedAtFieldToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :ended_at, :datetime, :default => nil
  end
end
