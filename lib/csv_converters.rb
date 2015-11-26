# Read more about this here: http://technicalpickles.com/posts/parsing-csv-with-ruby/

CSV::HeaderConverters[:transliterate] = lambda do |header|
  header && I18n.transliterate(header)
end

CSV::Converters[:blank_to_nil] = lambda do |field|
  field && field.empty? ? nil : field
end
