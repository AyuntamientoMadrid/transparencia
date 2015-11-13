class CreatePerson < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.references :party

      t.string :name
      t.string :email
      t.string :gender
      t.string :role
      t.float  :salary
    end
  end
end
