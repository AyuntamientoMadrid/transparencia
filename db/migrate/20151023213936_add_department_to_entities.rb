class AddDepartmentToEntities < ActiveRecord::Migration
  def change
    add_column :entities, :department_id, :integer
  end
end
