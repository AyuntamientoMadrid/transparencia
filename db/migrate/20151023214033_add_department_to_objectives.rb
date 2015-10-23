class AddDepartmentToObjectives < ActiveRecord::Migration
  def change
    add_column :objectives, :department_id, :integer
  end
end