class CreateAliases < ActiveRecord::Migration
  def change
    create_table :aliases do |t|
      t.belongs_to :address
      t.string :to
      t.string :description

      t.timestamps
    end

    add_index :aliases, :to, :unique => true
  end
end
