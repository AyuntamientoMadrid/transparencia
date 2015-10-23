class AddEntityToActions < ActiveRecord::Migration
  def change
    add_column :actions, :department_id, :integer
  end
end
