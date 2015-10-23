class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.string :title
      t.text :description
      t.integer :order
      t.boolean :accomplished
    end
  end
end
