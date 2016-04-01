require 'rails_helper'
require 'sorting_name_calculator'

describe SortingNameCalculator do

  describe '#calculate' do

    it "downcases & transliterates everything, putting last_name first" do
      expect(subject.calculate("María", "Gutierrez López")).to eq("gutierrez lopez maria")
    end

    it "removes stop words from the first name but not from the last name" do
      expect(subject.calculate("María de las Mercedes", "de la Cueva del Río")).to eq("cueva rio maria de las mercedes")
    end

  end
end
