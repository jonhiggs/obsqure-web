class AddGuideCompleteToUsers < ActiveRecord::Migration
  def change
    add_column :users, :guide_complete, :boolean, :default => false
  end
end
