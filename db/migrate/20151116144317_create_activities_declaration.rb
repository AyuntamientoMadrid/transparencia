class CreateActivitiesDeclaration < ActiveRecord::Migration
  def change
    create_table :activities_declarations do |t|
      t.references :person
      t.datetime :start_date
      t.datetime :end_date
      t.json :data
    end
  end
end
