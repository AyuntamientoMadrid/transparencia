class CreateFileUploads < ActiveRecord::Migration
  def change
    create_table :file_uploads do |t|
      t.string :type
      t.string :original_filename
      t.string :file_format
      t.text :log
      t.boolean :successful

      t.timestamps null: false
    end

    add_reference :file_uploads, :author, references: :administrator, index: true
    add_foreign_key :file_uploads, :administrators, column: :author_id
  end
end
