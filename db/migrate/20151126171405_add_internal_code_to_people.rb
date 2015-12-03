class AddInternalCodeToPeople < ActiveRecord::Migration
  def change
    add_column :people, :internal_code, :integer
  end
end
