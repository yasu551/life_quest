class AddCompletedToTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :tasks, :completed_on, :date
  end
end
