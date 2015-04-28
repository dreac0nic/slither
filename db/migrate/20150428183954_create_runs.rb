class CreateRuns < ActiveRecord::Migration
  def change
    create_table :runs do |t|
      t.integer :user_id
      t.integer :score
      t.time :duration
      t.integer :dots
      t.boolean :completed
      t.datetime :finished_on

      t.timestamps null: false
    end
  end
end
