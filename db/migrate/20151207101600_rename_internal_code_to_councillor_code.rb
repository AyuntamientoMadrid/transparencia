class RenameInternalCodeToCouncillorCode < ActiveRecord::Migration
  def change
    rename_column :people, :internal_code, :councillor_code
  end
end
