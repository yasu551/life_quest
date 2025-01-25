class RemoveNotNullConstraintFromActivitiesTaskPerformedAt < ActiveRecord::Migration[8.0]
  def change
    change_column_null :activities, :performed_at, true
  end
end
