class AddPerformAtToActivities < ActiveRecord::Migration[8.0]
  def change
    add_column :activities, :perform_at, :datetime
  end
end
