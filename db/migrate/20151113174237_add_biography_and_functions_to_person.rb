class AddBiographyAndFunctionsToPerson < ActiveRecord::Migration
  def change
    add_column :people, :biography, :text
    add_column :people, :functions, :text
  end
end
