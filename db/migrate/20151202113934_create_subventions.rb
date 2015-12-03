class CreateSubventions < ActiveRecord::Migration
  def change
    create_table :subventions do |t|
      t.string :recipient, null: false
      t.string :project
      t.string :kind
      t.string :location
      t.integer :year
      t.integer :amount_euro_cents, null: false

      t.timestamps null: false
    end

    add_index :subventions, :recipient
  end
end
