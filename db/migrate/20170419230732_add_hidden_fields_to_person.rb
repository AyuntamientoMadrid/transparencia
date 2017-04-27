class AddHiddenFieldsToPerson < ActiveRecord::Migration
  def change
    add_column :people, :hidden_at, :datetime, index: true
    add_column :people, :hidden_by_id, :integer, index: true
    add_column :people, :hidden_reason, :string
    add_column :people, :unhidden_at, :datetime, index: true
    add_column :people, :unhidden_by_id, :integer, index: true
    add_column :people, :unhidden_reason, :string

    add_foreign_key :people, :administrators, column: :hidden_by_id
    add_foreign_key :people, :administrators, column: :unhidden_by_id
  end
end
