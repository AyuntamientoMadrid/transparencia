require 'importers/base_importer'

module Importers
  class ContractsImporter < BaseImporter
    def import!
      each_row do |row|
        center              = parse_text(row[:descripcion_centro])
        organism            = parse_text(row[:organismo])
        contract_number     = row[:numero_contrato]
        document_number     = row[:numero_expediente]
        description         = parse_text(row[:descripcion_contrato])
        kind                = row[:tipo_contrato]
        award_procedure     = row[:procedimiento_adjudicación]
        article             = row[:articulo]
        article_section     = row[:apartado]
        award_criteria      = row[:criterios_adjudicacion]
        budget_amount       = row[:presupuesto_total_iva_incluido]
        award_amount        = row[:importe_adjudicacion_iva_incluido]
        term                = row[:plazo]
        awarded_at          = parse_declaration_date(row[:fecha_adjudicacion])
        recipient           = parse_text(row[:nombrerazon_social])
        formalized_at       = parse_declaration_date(row[:fecha_formalizacion])
        framework_agreement = row[:acuerdo_marco]
        zero_cost_revenue   = row[:ingresocoste_cero]
        recipient_document_number = row[:nifcif_adjudicatario]

        euros, cents = budget_amount.split(',')
        cents ||= "00"
        budget_amount_cents = "#{euros}#{cents}".gsub(/[^0-9]/,'').to_i

        euros, cents = award_amount.split(',')
        cents ||= "00"
        award_amount_cents = "#{euros}#{cents}".gsub(/[^0-9]/,'').to_i

        puts "Importing August 2015 contract: #{recipient} - #{contract_number}"

        contract = Contract.find_or_initialize_by(contract_number: contract_number)
        contract.attributes = { center: center, organism: organism, contract_number: contract_number, document_number: document_number, description: description, kind: kind, award_procedure: award_procedure, article: article, article_section: article_section, award_criteria: award_criteria, budget_amount_cents: budget_amount_cents, award_amount_cents: award_amount_cents, term: term, awarded_at: awarded_at, recipient: recipient, formalized_at: formalized_at, framework_agreement: framework_agreement, zero_cost_revenue: zero_cost_revenue, recipient_document_number: recipient_document_number }
        contract.save!
      end
    end
  end
end