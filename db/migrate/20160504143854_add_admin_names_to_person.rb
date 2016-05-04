class AddAdminNamesToPerson < ActiveRecord::Migration
  def change
    add_column :people, :admin_first_name, :string
    add_index :people, :admin_first_name
    add_column :people, :admin_last_name, :string
    add_index :people, :admin_last_name
  end
end
