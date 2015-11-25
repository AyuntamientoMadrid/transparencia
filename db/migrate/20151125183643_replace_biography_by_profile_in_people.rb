class ReplaceBiographyByProfileInPeople < ActiveRecord::Migration
  def change
    remove_column :people, :biography, :text
    remove_column :people, :gender, :string
    add_column :people, :profile, :json
  end
end
