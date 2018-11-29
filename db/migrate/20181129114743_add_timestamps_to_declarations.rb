class AddTimestampsToDeclarations < ActiveRecord::Migration
  def change
    change_table(:assets_declarations) do |t|
      t.timestamps
    end

    change_table(:activities_declarations) do |t|
      t.timestamps
    end
  end
end
