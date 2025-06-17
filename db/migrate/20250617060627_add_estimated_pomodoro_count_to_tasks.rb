class AddEstimatedPomodoroCountToTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :tasks, :estimated_pomodoro_count, :integer
  end
end
