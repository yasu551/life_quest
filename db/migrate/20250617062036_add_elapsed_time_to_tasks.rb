class AddElapsedTimeToTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :tasks, :elapsed_time, :integer, null: false, default: 0
  end
end
