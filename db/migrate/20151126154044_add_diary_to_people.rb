class AddDiaryToPeople < ActiveRecord::Migration
  def change
    add_column :people, :diary, :string
  end
end
