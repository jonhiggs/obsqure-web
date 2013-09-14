class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.belongs_to :user
      t.boolean :default, :default => false
      t.boolean :verified, :default => false
      t.string :to
      t.timestamps
    end

    add_index :addresses, :to, :unique => true
  end
end
