class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.references :source, polymorphic: true, null: false
      t.string :title, null: false
      t.string :body, null: false, default: ""
      t.string :path, null: false, default: "/"

      t.timestamps
    end
  end
end
