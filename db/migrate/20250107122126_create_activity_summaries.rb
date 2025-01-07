class CreateActivitySummaries < ActiveRecord::Migration[8.0]
  def change
    create_table :activity_summaries do |t|
      t.date :start_on, null: false
      t.date :end_on, null: false
      t.text :content, null: false, default: ""
      t.text :memo, null: false, default: ""
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
