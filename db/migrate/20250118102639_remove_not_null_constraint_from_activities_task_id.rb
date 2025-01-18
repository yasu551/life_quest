class RemoveNotNullConstraintFromActivitiesTaskId < ActiveRecord::Migration[8.0]
  def change
    change_column_null :activities, :task_id, true
  end
end
