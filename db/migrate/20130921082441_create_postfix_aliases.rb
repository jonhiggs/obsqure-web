class CreatePostfixAliases < ActiveRecord::Migration
  def change
    create_table(:postfix_aliases, :id => false) do |t|
      t.string :from
      t.string :to
    end
    add_index :postfix_aliases, :from, :unique => true
  end
end
