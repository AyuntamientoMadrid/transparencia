class AddAncestryToPages < ActiveRecord::Migration
  def change
    add_column :pages, :ancestry, :string
    add_index :pages, :ancestry
  end

  def down
    remove_column :pages, :ancestry
    remove_index :pages, :ancestry
  end
end