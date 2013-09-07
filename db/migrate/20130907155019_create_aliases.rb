class CreateAliases < ActiveRecord::Migration
  def change
    create_table :aliases do |t|
      t.belongs_to :user
      t.string :address
      t.string :redirect_to

      t.timestamps
    end

    add_index :aliases, :address, :unique => true
  end
end
