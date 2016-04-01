module SortingNameCalculator

  STOP_WORDS = %{el, la, las, de, del, los, da, de, do, dos}

  def self.calculate(first_name, last_name)
     last_name = transliterate(last_name)
                  .downcase # need this so that spaces don't mess up with sort, never do uppercase here
                  .split(/\s+/)
                  .reject{|x| x.in? STOP_WORDS}
                  .join(' ')

     first_name = transliterate(first_name).downcase

     "#{last_name} #{first_name}"
  end

  private
    def self.transliterate(string)
      ActiveSupport::Inflector.transliterate(string)
    end

end
