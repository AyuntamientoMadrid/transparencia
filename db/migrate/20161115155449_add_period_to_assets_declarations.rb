class AddPeriodToAssetsDeclarations < ActiveRecord::Migration
  def change
    add_column :assets_declarations, :period, :string
  end
end
