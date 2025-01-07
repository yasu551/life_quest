class CreateTimeEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :time_entries do |t|
      t.references :task, null: false, index: false, foreign_key: true
      t.string :content, null: false

      t.timestamps
    end

    add_index :time_entries, %i[ task_id created_at ]
  end
end
