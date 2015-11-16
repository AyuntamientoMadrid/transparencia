class CreateAssetsDeclaration < ActiveRecord::Migration
  def change
    create_table :assets_declarations do |t|
      t.references :person
      t.date :start_date
      t.date :end_date
      t.json :data
    end
  end
end
