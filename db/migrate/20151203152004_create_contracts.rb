class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.string   :center
      t.string   :organism
      t.string   :contract_number
      t.string   :document_number
      t.text     :description
      t.string   :kind
      t.string   :award_procedure
      t.string   :article
      t.string   :article_section
      t.string   :award_criteria
      t.integer  :budget_amount_cents
      t.integer  :award_amount_cents
      t.string   :term
      t.date     :awarded_at
      t.string   :recipient
      t.string   :recipient_document_number
      t.date     :formalized_at
      t.boolean  :framework_agreement
      t.boolean  :zero_cost_revenue

      t.timestamps null: false
    end
  end
end
