class CreateObjectives < ActiveRecord::Migration
  def change
    create_table :objectives do |t|
      t.string :title
      t.text :description
      t.boolean :accomplished
      t.integer :order
    end
  end
end