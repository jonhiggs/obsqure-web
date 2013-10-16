class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.belongs_to :user
      t.string  :to
      t.string  :token
      t.timestamps
    end

    add_index :addresses, :to, :unique => true
    add_index :addresses, :token
  end
end
