class RemoveDurationFromRuns < ActiveRecord::Migration
  def change
    remove_column :runs, :duration, :time
  end
end
