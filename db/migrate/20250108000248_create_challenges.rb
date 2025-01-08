class CreateChallenges < ActiveRecord::Migration[8.0]
  def change
    create_table :challenges do |t|
      t.string :name, null: false
      t.text :description, null: false, default: ""
      t.datetime :perform_at
      t.datetime :performed_at
      t.boolean :active, null: false, default: true
      t.references :source, polymorphic: true, null: false

      t.timestamps
    end
  end
end
