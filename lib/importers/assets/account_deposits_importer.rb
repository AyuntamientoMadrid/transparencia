require 'importers/base_importer'

module Importers
  module Assets
    class AccountDepositsImporter < BaseImporter
      def import!
        each_row do |row|
          person = Person.find_by!(councillor_code: row[:codigopersona])

          declaration     = person.assets_declarations.last!
          kind            = row[:clase]
          banking_entity  = row[:entidad_de_deposito]
          balance         = row[:saldo_medio_anual_o_valor_euros]

          puts "Importing account balance for #{person.name} (#{kind}, #{banking_entity}, #{balance})"
          declaration.add_account_deposit(kind, banking_entity, balance)
          declaration.save!
        end
      end
    end
  end
end
