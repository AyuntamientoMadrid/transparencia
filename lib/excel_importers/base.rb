require 'html_table'

module ExcelImporters
  class Base
    attr_reader :headers
    attr_reader :logger
    attr_reader :file_format

    def initialize(path_to_file, header_field: nil, sheet_name: 0, logger: NullLogger.new)
      @path_to_file = path_to_file
      @header_field = header_field
      @sheet_name = sheet_name
      @logger = logger
    end

    def each_row(&_block)
      sheet.each_with_index do |row, row_index|
        next if row_index <= headers_row # skip header row
        row_hash = row_to_hash(row, row_index)
        next if row_hash.values.all?(&:blank?)
        yield(row_hash, row_index + 1)
      end && true
    end

    def index(header)
      hash_headers.index(header) ||
        headers.index(header) ||
        raise("could not find header: #{header}")
    end

    def import_row!(row, row_index)
      logger.info(row.inspect)
    end

    def import!
      each_row { |row, row_index| import_row!(row, row_index) }
    end

    def import
      ActiveRecord::Base.transaction do
        import!
      end
      true
    rescue => err
      logger.error(err.message)
      false
    end

    def headers
      unless @headers
        if @header_field.present?
          sheet.each_with_index do |row, row_index|
            if row.first == @header_field
              @headers_row = row_index
              @headers = row
              break
            end
          end
        else
          @headers_row = 0
          @headers = sheet.first
        end
        unless @headers
          raise I18n.t('excel_importers.base.could_not_find_header',
                       header: @header_field)
        end
      end
      @headers
    end

    def headers_row
      headers && @headers_row
    end

    def hash_headers
      @hash_headers ||= headers.map do |h|
        transliterate(h).parameterize('_').to_sym
      end
    end

    def self.new_default_logger(io = STDOUT)
      logger = Logger.new(io)
      logger.formatter = proc do |severity, _datetime, _progname, msg|
        "#{severity}: #{msg}\n"
      end
      logger
    end

    class NullLogger
      def info(str) end

      def error(str) end
    end

    private

      def sheet
        unless @sheet
          begin
            @xls   = Roo::Spreadsheet.open(@path_to_file)
            @sheet = @xls.sheet(@sheet_name)
            @file_format = :xls
          rescue Ole::Storage::FormatError
            @xls = nil
            @sheet = HTMLTable.open(@path_to_file)
            @file_format = :html
          end
        end
        @sheet
      end

      def row_to_hash(row, row_index)
        row_hash = {}
        row.each_with_index do |value, col_index|
          value = transform_value(value, col_index, row_index)
          row_hash[col_index] = value
          row_hash[hash_headers[col_index]] ||= value
        end
        row_hash
      end

      def transform_value(value, col_index, row_index)
        formatted_val = formatted_value(value, col_index, row_index)
        if formatted_val.present?
          formatted_val
        elsif value.is_a?(Float) &&
              value.round == value
          value.round
        elsif value == 'NULL'
          nil
        else
          value
        end
      end

      def formatted_value(value, col_index, row_index)
        if worksheet.present? && value.is_a?(Float)
          number_format = worksheet.row(row_index).format(col_index).number_format
          if number_format['€']
            ActiveSupport::NumberHelper.number_to_currency(value, locale: :es)
          elsif number_format['%']
            ActiveSupport::NumberHelper.number_to_percentage(value)
          end
        end
      end

      # Access the Spreadsheet gem's worksheet object
      def worksheet
        unless @xls.nil?
          @worksheet ||= @xls.workbook.worksheet(@xls.send(:sheet_no, @sheet_name))
        end
      end

      def transliterate(str)
        ActiveSupport::Inflector.transliterate((str || '').to_s)
      end
  end
end
