class CreateActivitiesDeclaration < ActiveRecord::Migration
  def change
    create_table :activities_declarations do |t|
      t.references :person
      t.date :start_date
      t.date :end_date
      t.json :data
    end
  end
end
