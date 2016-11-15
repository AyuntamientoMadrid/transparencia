class AddPeriodToActivitiesDeclarations < ActiveRecord::Migration
  def change
    add_column :activities_declarations, :period, :string
  end
end
