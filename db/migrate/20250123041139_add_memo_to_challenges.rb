class AddMemoToChallenges < ActiveRecord::Migration[8.0]
  def change
    add_column :challenges, :memo, :text, null: false, default: ""
  end
end
