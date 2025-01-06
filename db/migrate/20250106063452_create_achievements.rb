class CreateAchievements < ActiveRecord::Migration[8.0]
  def change
    create_table :achievements do |t|
      t.string :name, null: false
      t.text :description, null: false, default: ''
      t.text :memo, null: false, default: ''
      t.references :parent, foreign_key: { to_table: :achievements }
      t.references :user, null: false, foreign_key: true
      t.date :achieved_on
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  end
end
