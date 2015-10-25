class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.string :subtitle
      t.text :content
      t.string :link
      t.timestamps
    end
  end
end
