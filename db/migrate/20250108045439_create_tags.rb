class CreateTags < ActiveRecord::Migration[8.0]
  def change
    create_table :tags do |t|
      t.string :name, null: false, index: true
      t.string :color, null: false
      t.references :user, null: false, index: false, foreign_key: true

      t.timestamps
    end

    add_index :tags, %i[ user_id name ], unique: true
  end
end
