class ChangeSubventionsAmount < ActiveRecord::Migration
  def change
    rename_column :subventions, :amount_euro_cents, :amount_cents
  end
end
