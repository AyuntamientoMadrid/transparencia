class AddTwitterAndFacebookToPeople < ActiveRecord::Migration
  def change
    add_column :people, :twitter, :string
    add_column :people, :facebook, :string
  end
end
