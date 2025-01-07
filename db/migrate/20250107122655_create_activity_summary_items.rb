class CreateActivitySummaryItems < ActiveRecord::Migration[8.0]
  def change
    create_table :activity_summary_items do |t|
      t.references :activity_summary, null: false, index: false, foreign_key: true
      t.references :activity, null: false, foreign_key: true

      t.timestamps
    end

    add_index :activity_summary_items, %i[ activity_summary_id activity_id ], unique: true
  end
end
