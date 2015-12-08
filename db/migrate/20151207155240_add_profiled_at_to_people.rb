class AddProfiledAtToPeople < ActiveRecord::Migration
  def change
    add_column :people, :profiled_at, :datetime
  end
end
