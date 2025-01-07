class CreateActivityEvaluations < ActiveRecord::Migration[8.0]
  def change
    create_table :activity_evaluations do |t|
      t.string :value, null: false, default: "neutral"
      t.text :reason, null: false, default: ""
      t.references :activity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
