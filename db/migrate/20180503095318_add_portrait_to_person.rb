class AddPortraitToPerson < ActiveRecord::Migration
  def up
    add_attachment :people, :portrait
  end

  def down
    remove_attachment :people, :portrait
  end
end
