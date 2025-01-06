class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.text :completion_condition, null: false, default: ''
      t.string :status, null: false, default: 'new'
      t.date :deadline_on
      t.text :sub_tasks, null: false, default: ''
      t.text :memo, null: false, default: ''
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
