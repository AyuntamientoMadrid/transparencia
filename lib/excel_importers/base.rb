module ExcelImporters
  class Base
    attr_reader :headers

    def initialize(path_to_file, headers_row: 1, logger: NullLogger.new)
      @book = Spreadsheet.open(path_to_file)
      @headers_row = headers_row
      @headers = @book.worksheet(0).row(headers_row)
      @transformed_headers = @headers.map { |h| transform_header(h) }
      @logger = logger
    end

    def each_row(&_block)
      @book.worksheet(0).each_with_index do |row, row_index|
        next if row_index <= @headers_row # skip header row
        row_hash = row_to_hash(row)
        next if row_hash.values.all?(&:blank?)
        yield(row_hash)
      end && true
    end

    def index(header)
      @transformed_headers.index(header) ||
        @headers.index(header) ||
        raise("could not find header: #{header}")
    end

    def import!
      each_row { |row| puts row.inspect }
    end

    def safe_import!
      begin
        import!
        true
      rescue StandardError => error
        @logger.puts(error.to_s)
        false
      end
    end

    def puts(str)
      @logger.puts(str)
    end

    class NullLogger
      def puts(str)
      end
    end

    private

      def row_to_hash(row)
        row_hash = {}
        row.each_with_index do |value, col_index|
          value = transform_value(value, row.format(col_index).number_format)
          row_hash[col_index] = value
          row_hash[@transformed_headers[col_index]] ||= value
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

      def transform_header(header)
        transliterate(header).parameterize('_').to_sym
      end

      def transliterate(str)
        ActiveSupport::Inflector.transliterate((str || '').to_s)
      end
  end
end
