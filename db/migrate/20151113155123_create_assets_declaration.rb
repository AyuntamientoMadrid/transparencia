class CreateAssetsDeclaration < ActiveRecord::Migration
  def change
    create_table :assets_declarations do |t|
      t.references :person
      t.datetime :start_date
      t.datetime :end_date
      t.hstore :data
    end
  end
end
