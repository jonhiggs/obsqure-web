class AddBurntToAliases < ActiveRecord::Migration
  def change
    add_column :aliases, :burnt, :boolean, :default => false
  end
end
