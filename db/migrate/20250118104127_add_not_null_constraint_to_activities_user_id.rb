class AddNotNullConstraintToActivitiesUserId < ActiveRecord::Migration[8.0]
  def change
    change_column_null :activities, :user_id, false
  end
end
