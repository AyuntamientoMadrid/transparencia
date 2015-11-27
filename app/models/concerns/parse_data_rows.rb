require 'ostruct'

module ParseDataRows

  def parse_data_rows(collection_name)
    data = self.data|| {}
    col = data[collection_name] || []
    col.collect{ |row| parse_data_row(row) }
  end

  def parse_data_row(row)
    row = row.dup
    row.each do |key, value|
      if key.end_with?('_date') then
        row[key] = value ? Date.parse(value) : nil
      end
    end
    OpenStruct.new(row)
  end

end
