require 'html_table'

module ExcelImporters
  class Base
    attr_reader :headers
    attr_reader :logger
    attr_reader :file_format

    def initialize(path_to_file, header_field: nil, logger: NullLogger.new)
      @path_to_file = path_to_file
      @header_field = header_field
      @logger = logger
    end

    def each_row(&_block)
      headers # forces calculation of @headers & @headers_row
      sheet.each_with_index do |row, row_index|
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

    def import
      ActiveRecord::Base.transaction do
        import!
        true
      end
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

      def sheet
        unless @sheet
          begin
            @sheet = Roo::Spreadsheet.open(@path_to_file).sheet(0)
            @file_format = :xls
          rescue Ole::Storage::FormatError
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
        if value.is_a?(Float) &&
           value.round == value
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
