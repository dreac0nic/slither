class AddStartOnToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :start_on, :datetime
  end
end
