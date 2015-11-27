class AddLongNameToParties < ActiveRecord::Migration
  def change
    add_column :parties, :long_name, :string
  end
end
