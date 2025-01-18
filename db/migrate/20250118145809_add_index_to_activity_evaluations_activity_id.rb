class AddIndexToActivityEvaluationsActivityId < ActiveRecord::Migration[8.0]
  def change
    remove_index :activity_evaluations, :activity_id
    add_index :activity_evaluations, :activity_id, unique: true
  end
end
