require 'ostruct'

module ParseDataRows

  def parse_data_rows(data_hash, collection_name)
    data_hash[collection_name.to_s].collect{ |row| parse_data_row(row) }
  end

  def parse_data_row(row)
    row = row.dup
    row.each do |key, value|
      if key.end_with?('_date') then
        row[key] = Date.parse(value)
      end
    end
    OpenStruct.new(row)
  end

end
