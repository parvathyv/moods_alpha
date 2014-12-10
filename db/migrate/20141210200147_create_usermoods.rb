class CreateUsermoods < ActiveRecord::Migration
  def change
  	create_table :usermoods do |table|
      table.string :user_id, null: false
      table.string :color, null: false
      table.text :comments, null: false
      table.string :mood_type, null: false
      table.timestamps
    end
  end
end
