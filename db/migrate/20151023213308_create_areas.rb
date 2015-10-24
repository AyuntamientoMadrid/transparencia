class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.string :name
    end
  end
end