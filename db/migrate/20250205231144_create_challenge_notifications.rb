class CreateChallengeNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :challenge_notifications do |t|
      t.references :challenge, null: false, foreign_key: true

      t.timestamps
    end
  end
end
