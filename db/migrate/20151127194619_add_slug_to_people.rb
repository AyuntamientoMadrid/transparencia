class AddSlugToPeople < ActiveRecord::Migration
  def change
    add_column :people, :slug, :string
    add_index :people, :slug, unique: true
  end
end
