class RemoveParentIdFromPages < ActiveRecord::Migration
  def change
    remove_column :pages, :parent_id
  end
end
