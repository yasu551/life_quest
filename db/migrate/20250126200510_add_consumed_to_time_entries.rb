class AddConsumedToTimeEntries < ActiveRecord::Migration[8.0]
  def change
    add_column :time_entries, :consumed, :boolean, null: false, default: false
  end
end
