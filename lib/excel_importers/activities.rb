require 'excel_importers/base'
require 'logger'

module ExcelImporters
  class Activities
    def initialize(path_to_file, period, logger = ExcelImporters::Base::NullLogger.new)
      @path_to_file = path_to_file
      @period = period
      @logger = logger
    end

    def import
      declarations = Declarations.new(@path_to_file,
                                      @period,
                                      logger: @logger,
                                      sheet_name: '1_DatosPersonales')
      pub = Public.new(@path_to_file,
                       @period,
                       logger: @logger,
                       sheet_name: '3_1PuestosDeTrabajo')
      priv = Private.new(@path_to_file,
                         @period,
                         logger: @logger,
                         sheet_name: '3_2ActividadesPrivadas')
      other = Other.new(@path_to_file,
                        @period,
                        logger: @logger,
                        sheet_name: '3_3OtrasActividades')

      ActiveRecord::Base.transaction do
        declarations.import! && pub.import! && priv.import! && other.import!
      end
      true
    rescue => err
      @logger.error(err.message)
      false
    end

    class Period < ::ExcelImporters::Base
      def initialize(path_to_file, period, logger: nil, sheet_name: nil)
        super(path_to_file, logger: logger, sheet_name: sheet_name)
        @period = period
      end

      def get_person(row)
        Person.find_by!(councillor_code: row[:codigopersona])
      end
    end

    class Declarations < Period
      def import_row!(row)
        person = get_person(row)
        declaration_date = row[:fecha_de_declaracion]
        person.activities_declarations.find_or_create_by!(period: @period, declaration_date: declaration_date)
        logger.info(I18n.t('excel_importers.activities.declarations.imported', person: person.name, date: declaration_date))
      end
    end

    class Public < Period
      def import_row!(row)
        person = get_person(row)
        declaration = person.activities_declarations.for_period(@period).first!

        entity     = row[:entidad]
        position   = row[:cargo_o_categoria]
        start_date = row[:fecha_inicio]
        end_date   = row[:fecha_cese]

        logger.info(I18n.t('excel_importers.activities.public.imported',
                           period: @period,
                           person: person.name,
                           entity: entity,
                           position: position,
                           start_date: start_date,
                           end_date: end_date))
        declaration.add_public_activity(entity, position, start_date, end_date)
        declaration.save!
      end
    end

    class Private < Period
      def import_row!(row)
        person = get_person(row)
        declaration = person.activities_declarations.for_period(@period).first!

        kind        = row[:actividad]
        description = row[:descripcion]
        entity      = row[:entidad_colegio_profesional]
        position    = row[:cargo_o_categoria]
        start_date  = row[:fecha_inicio]
        end_date    = row[:fecha_cese]

        logger.info(I18n.t('excel_importers.activities.private.imported',
                           period: @period,
                           person: person.name,
                           kind: kind,
                           entity: entity,
                           position: position,
                           start_date: start_date,
                           end_date: end_date))

        declaration.add_private_activity(kind, description, entity, position, start_date, end_date)
        declaration.save!
      end
    end

    class Other < Period
      def import_row!(row)
        person = get_person(row)
        declaration = person.activities_declarations.for_period(@period).first!

        description = row[:descripcion]
        start_date  = row[:fecha_inicio]
        end_date    = row[:fecha_cese]

        logger.info(I18n.t('excel_importers.activities.other.imported',
                           period: @period,
                           person: person.name,
                           start_date: start_date,
                           end_date: end_date))

        declaration.add_other_activity(description, start_date, end_date)
        declaration.save!
      end
    end

  end
end
