class ChangeDatesInDeclarations < ActiveRecord::Migration
  def change
    remove_column :assets_declarations, :end_date, :date
    remove_column :activities_declarations, :end_date, :date

    rename_column :assets_declarations, :start_date, :declaration_date
    rename_column :activities_declarations, :start_date, :declaration_date
  end
end
