class AddPersonalCodeToPeople < ActiveRecord::Migration
  def change
    add_column :people, :personal_code, :integer
  end
end
