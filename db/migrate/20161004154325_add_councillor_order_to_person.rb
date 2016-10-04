class AddCouncillorOrderToPerson < ActiveRecord::Migration
  def change
    add_column :people, :councillor_order, :integer
  end
end
