class AddCouncillorsCountToParties < ActiveRecord::Migration
  def change
    add_column :parties, :councillors_count, :integer, default: 0
  end
end
