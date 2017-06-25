class AddPeriodToFileUploads < ActiveRecord::Migration
  def change
    add_column :file_uploads, :period, :string
  end
end
