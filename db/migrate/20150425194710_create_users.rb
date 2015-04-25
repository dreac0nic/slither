class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :handle
      t.string :password
      t.string :email
      t.string :first_name
      t.string :last_name

      t.timestamps null: false
    end
  end
end
