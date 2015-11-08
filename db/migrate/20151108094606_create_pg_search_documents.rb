class CreatePgSearchDocuments < ActiveRecord::Migration
  def self.up
    create_table :pg_search_documents do |t|
      t.text :content
      t.belongs_to :searchable, :polymorphic => true, :index => true
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :pg_search_documents
  end
end
