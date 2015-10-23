class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areasa do |t|
      t.string :name
    end
  end
end