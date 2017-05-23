module SortingNameCalculator

  def self.calculate(first_name, last_name)
     last_name = transliterate(last_name)
                  .downcase # need this so that spaces don't mess up with sort, never do uppercase here
                  .gsub('-', '')
                  .split(/\s+/)
                  .join(' ')

     first_name = transliterate(first_name).downcase

     "#{last_name} #{first_name}"
  end

  private
    def self.transliterate(string)
      ActiveSupport::Inflector.transliterate(string)
    end

end
