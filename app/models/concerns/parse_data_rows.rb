require 'ostruct'

module ParseDataRows

  def parse_data_rows(data_hash, collection_name)
    data_hash ||= {}
    (data_hash[collection_name.to_s] || []).collect{ |row| OpenStruct.new(row) }
  end

end
