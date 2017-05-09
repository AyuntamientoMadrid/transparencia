class AddSecondaryRoleToPeople < ActiveRecord::Migration
  def change
    add_column :people, :secondary_role, :string
  end
end
