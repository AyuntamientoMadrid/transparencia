require 'ostruct'

module ParseDataRows

  def parse_data_rows(collection_name)
    data = self.data|| {}
    col = data[collection_name] || []
    col.collect{ |row| OpenStruct.new(row) }
  end

end
