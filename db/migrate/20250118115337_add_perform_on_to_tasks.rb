class AddPerformOnToTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :tasks, :perform_on, :date
  end
end
