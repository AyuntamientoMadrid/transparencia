require 'csv_converters'

module Importers
  class BaseImporter

    OPTIONS = {
      headers: true,
      header_converters: [:transliterate, :symbol],
      converters: [:all, :blank_to_nil]
    }

    def initialize(path_to_file)
      @path_to_file = path_to_file
    end

    def each_row(&block)
      CSV.foreach(@path_to_file, OPTIONS) do |row|
        block.call(row)
      end
    end

    def import!
      each_row{ |row| puts row.inspect }
    end

    def parse_declaration_date(str)
      day, month, year = str.split(/[-\/]/)
      day, month, year = day.to_i, month.to_i, year.to_i
      begin
        Date.new(year, month, day)
      rescue ArgumentError # dates with day and month flipped
        Date.new(year, day, month)
      end
    end

    def parse_spanish_date(str)
      return nil if str.blank?
      day, month, year = str.to_s.split('/')
      return nil unless day.present? && month.present? && year.present?

      day, month, year = day.to_i, month.to_i, year.to_i
      begin
        Date.new(year, month, day)
      rescue ArgumentError # dates with day and month flipped
        Date.new(year, day, month)
      end
    end

    def parse_text(str)
      return '' if str.blank?
      str.mb_chars.capitalize
    end

    private

      def calculate_decimal_places_divider(str)
        return 100 if str[-3] == '.' || str[-3] == ','
        return 10  if str[-2] == '.' || str[-2] == ','
        return 1
      end
  end
end
