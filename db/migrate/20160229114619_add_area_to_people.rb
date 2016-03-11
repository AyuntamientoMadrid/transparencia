class AddAreaToPeople < ActiveRecord::Migration
  def change
    add_column :people, :area, :string
  end
end
