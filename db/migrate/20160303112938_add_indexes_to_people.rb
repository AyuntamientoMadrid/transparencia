class AddIndexesToPeople < ActiveRecord::Migration
  def change
    add_index :people, :job_level
    add_index :people, :name
    add_index :people, :area
    add_index :people, :party_id
  end
end
