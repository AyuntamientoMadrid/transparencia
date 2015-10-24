class CreateObjectives < ActiveRecord::Migration
  def change
    create_table :objectives do |t|
      t.string :title
      t.text :description
      t.boolean :accomplished, default: false
      t.integer :order
    end
  end
end