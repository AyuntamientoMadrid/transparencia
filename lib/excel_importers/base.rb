module ExcelImporters
  class Base
    attr_reader :headers
    attr_reader :logger

    def initialize(path_to_file, header_field, logger: NullLogger.new)
      @path_to_file = path_to_file
      @header_field = header_field
      @logger = logger
    end

    def each_row(&_block)
      headers # forces calculation of @headers & @headers_row
      book.sheet(0).each_with_index do |row, row_index|
        next if row_index <= @headers_row # skip header row
        row_hash = row_to_hash(row, row_index)
        next if row_hash.values.all?(&:blank?)
        yield(row_hash)
      end && true
    end

    def index(header)
      hash_headers.index(header) ||
        headers.index(header) ||
        raise("could not find header: #{header}")
    end

    def import!
      each_row { |row| logger.info(row.inspect) }
    end

    def safe_import!
      import!
      true
    rescue => err
      logger.error(err.message)
      false
    end

    def headers
      unless @headers
        sheet = book.sheet(0)
        (sheet.first_row .. sheet.last_row).each do |row_index|
          if sheet.cell(row_index, 1) == @header_field
            @headers_row = row_index
            @headers = sheet.row(row_index)
            break
          end
        end
        unless @headers
          raise I18n.t('excel_importers.base.could_not_find_header', header: @header_field)
        end
      end
      @headers
    end

    def hash_headers
      @hash_headers ||= headers.map do |h|
        transliterate(h).parameterize('_').to_sym
      end
    end

    class NullLogger
      def info(str) end

      def error(str) end
    end

    private

      def book
        @book ||= Roo::Spreadsheet.open(@path_to_file)
      end

      def row_to_hash(row, row_index)
        row_hash = {}
        row.each_with_index do |value, col_index|
          value = transform_value(value, is_general_number?(col_index, row_index))
          row_hash[col_index] = value
          row_hash[hash_headers[col_index]] ||= value
        end
        row_hash
      end

      def is_general_number?(col_index, row_index)
        if book.respond_to?(:workbook) # xls, use spreadsheet gem to get format
          sheet = book.workbook.worksheets.first
          sheet.rows[row_index].format(col_index).number_format == 'General'
        else
          debugger
        end
      end

      def transform_value(value, general_number)
        if value.is_a?(Float) &&
           value.round == value &&
           general_number
          value.round
        elsif value == 'NULL'
          nil
        else
          value
        end
      end

      def transliterate(str)
        ActiveSupport::Inflector.transliterate((str || '').to_s)
      end
  end
end
