require 'excel_importers/base'
require 'logger'

module ExcelImporters
  class Assets
    def initialize(path_to_file, period, logger = ExcelImporters::Base::NullLogger.new)
      @path_to_file = path_to_file
      @period = period
      @logger = logger
    end

    def import
      declarations = Declarations.new(@path_to_file,
                                      @period,
                                      logger: @logger,
                                      sheet_name: '1.DatosPersonales')
      real_estate_properties = RealEstateProperties.new(@path_to_file,
                                                        @period,
                                                        logger: @logger,
                                                        sheet_name: '3.PatrimonioInmobiliario')
      account_deposits = AccountDeposits.new(@path_to_file,
                                             @period,
                                             logger: @logger,
                                             sheet_name: '4.DepositosEnCuenta')
      other_deposits = OtherDeposits.new(@path_to_file,
                                         @period,
                                         logger: @logger,
                                         sheet_name: '5. OtrosDepositosEnCuenta')
      vehicles = Vehicles.new(@path_to_file,
                              @period,
                              logger: @logger,
                              sheet_name: '6.Vehículos')
      other_personal_properties = OtherPersonalProperties.new(@path_to_file,
                                                              @period,
                                                              logger: @logger,
                                                              sheet_name: '7.OtrosBienesMuebles')
      debts = Debts.new(@path_to_file,
                        @period,
                        logger: @logger,
                        sheet_name: '8.Deudas')

      tax_data = TaxData.new(@path_to_file,
                             @period,
                             logger: @logger,
                             sheet_name: '9.InformacionTributaria')

      ActiveRecord::Base.transaction do
        declarations.import! &&
          real_estate_properties.import! &&
          account_deposits.import! &&
          other_deposits.import! &&
          vehicles.import!
          other_personal_properties.import!
          debts.import!
          tax_data.import!
      end
      true
    rescue => err
      @logger.error(err.message)
      false
    end

    class AssetsBaseImporter < ::ExcelImporters::Base
      def initialize(path_to_file, period, logger: nil, sheet_name: nil)
        super(path_to_file, logger: logger, sheet_name: sheet_name)
        @period = period
      end

      def get_declaration(person)
        person.assets_declarations.for_period(@period).first!
      end

      def import_row!(row, row_index)
        identifier = row.fetch(:identificador)
        if identifier.present?
          person = Person.find_by(personal_code: identifier)
          if person.present?
            import_person_row!(person, row)
          else
            logger.error("DATA PROBLEM!! No Person found for identifier #{identifier} at row #{row_index}")
          end
        else
          logger.error("DATA PROBLEM!! No identifier found at row #{row_index}")
        end
      end
    end

    class Declarations < AssetsBaseImporter
      def import_person_row!(person, row)
        declaration = person.assets_declarations.find_or_initialize_by(period: @period)
        declaration.declaration_date = row[:fecha_de_declaracion]
        declaration.save!
        logger.info(I18n.t('excel_importers.assets.declarations.imported', person: person.name, date: declaration.declaration_date))
      end
    end

    class RealEstateProperties < AssetsBaseImporter
      def import_person_row!(person, row)
        declaration = get_declaration(person)

        kind           = row[:clase]
        type           = row[:tipo_de_derecho]
        description    = row[:titulo_de_adquisicion]
        municipality   = row[:municipio]
        share          = row[:participacion].to_s.gsub(".", ",")
        purchase_date  = row[:fecha_de_adquisicion]
        tax_value      = row[:valor_catastral]
        notes          = row[:observaciones]

        declaration.add_real_estate_property(kind, type, description, municipality,
                                             share, purchase_date, tax_value, notes)
        declaration.save!

        logger.info(I18n.t('excel_importers.assets.real_estate_properties.imported',
                           period: @period,
                           person: person.name,
                           kind: kind,
                           type: type,
                           municipality: municipality,
                           share: share,
                           purchase_date: purchase_date,
                           tax_value: tax_value,
                           notes: notes))
      end
    end

    class AccountDeposits < AssetsBaseImporter
      def import_person_row!(person, row)
        declaration = get_declaration(person)

        kind            = row[:clase]
        banking_entity  = row[:entidad_de_deposito]
        balance         = row[:saldo_medio_anual_o_valor_euros]

        declaration.add_account_deposit(kind, banking_entity, balance)
        declaration.save!

        logger.info(I18n.t('excel_importers.assets.account_deposits.imported',
                           period: @period,
                           person: person.name,
                           kind: kind,
                           banking_entity: banking_entity,
                           balance: balance))
      end
    end

    class OtherDeposits < AssetsBaseImporter
      def import_person_row!(person, row)
        declaration = get_declaration(person)

        kind           = row[:clase]
        description    = row[:descripcion]
        amount         = row[:numero_cuantia_o_valor_en_euros]
        purchase_date  = row[:fecha_de_adquisicion]

        declaration.add_other_deposit(kind, description, amount, purchase_date)
        declaration.save!

        logger.info(I18n.t('excel_importers.assets.other_deposits.imported',
                           period: @period,
                           person: person.name,
                           kind: kind,
                           description: description,
                           amount: amount,
                           purchase_date: purchase_date))
      end
    end

    class Vehicles < AssetsBaseImporter
      def import_person_row!(person, row)
        declaration = get_declaration(person)

        kind           = row[:clase]
        model          = row[:marca_y_modelo]
        purchase_date  = row[:fecha_de_adquisicion]

        declaration.add_vehicle(kind, model, purchase_date)
        declaration.save!

        logger.info(I18n.t('excel_importers.assets.vehicles.imported',
                           period: @period,
                           person: person.name,
                           kind: kind,
                           model: model,
                           purchase_date: purchase_date))
      end
    end

    class OtherPersonalProperties < AssetsBaseImporter
      def import_person_row!(person, row)
        declaration = get_declaration(person)

        kind           = row[:clase]
        purchase_date  = row[:fecha_de_adquisicion]

        declaration.add_other_personal_property(kind, purchase_date)
        declaration.save!

        logger.info(I18n.t('excel_importers.assets.other_personal_properties.imported',
                           period: @period,
                           person: person.name,
                           kind: kind,
                           purchase_date: purchase_date))
      end
    end

    class Debts < AssetsBaseImporter
      def import_person_row!(person, row)
        declaration = get_declaration(person)

        kind           = row[:clase]
        amount         = row[:importe_actual_en_euros]
        comments       = row[:observaciones]

        declaration.add_debt(kind, amount, comments)
        declaration.save!

        logger.info(I18n.t('excel_importers.assets.debts.imported',
                           period: @period,
                           person: person.name,
                           kind: kind,
                           amount: amount,
                           comments: comments))
      end
    end

    class TaxData < AssetsBaseImporter
      def import_person_row!(person, row)
        declaration = get_declaration(person)

        tax         = row [:impuesto]
        fiscal_data = row[:dato_fiscal]
        amount      = row[:importe]
        comments    = row[:observaciones]

        declaration.add_tax_data(tax, fiscal_data, amount, comments)
        declaration.save!

        logger.info(I18n.t('excel_importers.assets.tax_data.imported',
                           period: @period,
                           person: person.name,
                           tax: tax,
                           fiscal_data: fiscal_data,
                           amount: amount,
                           comments: comments))
      end
    end

  end
end
