class CreateActivities < ActiveRecord::Migration[8.0]
  def change
    create_table :activities do |t|
      t.string :name, null: false
      t.datetime :performed_at, null: false
      t.text :memo, null: false, default: ""
      t.references :task, null: false, index: false, foreign_key: true

      t.timestamps
    end

    add_index :activities, %i[ task_id performed_at ]
  end
end
