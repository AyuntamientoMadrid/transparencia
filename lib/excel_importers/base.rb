module ExcelImporters
  class Base
    attr_reader :headers
    attr_reader :logger

    def initialize(path_to_file, headers_row: 1, logger: NullLogger.new)
      @path_to_file = path_to_file
      @headers_row = headers_row
      @logger = logger
    end

    def each_row(&_block)
      book.worksheet(0).each_with_index do |row, row_index|
        next if row_index <= @headers_row # skip header row
        row_hash = row_to_hash(row)
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
      @headers ||= book.worksheet(0).row(@headers_row)
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
        @book ||= Spreadsheet.open(@path_to_file)
      end

      def row_to_hash(row)
        row_hash = {}
        row.each_with_index do |value, col_index|
          value = transform_value(value, row.format(col_index).number_format)
          row_hash[col_index] = value
          row_hash[hash_headers[col_index]] ||= value
        end
        row_hash
      end

      def transform_value(value, number_format)
        if value.is_a?(Float) &&
           value.round == value &&
           number_format == 'GENERAL'
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
