class CreateParty < ActiveRecord::Migration
  def change
    create_table :parties do |t|
      t.string :name
      t.string :logo
    end
  end
end
