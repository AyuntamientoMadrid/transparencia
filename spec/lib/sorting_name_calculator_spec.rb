require 'rails_helper'
require 'sorting_name_calculator'

describe SortingNameCalculator do

  describe '#calculate' do

    it "downcases & transliterates everything, putting last_name first" do
      expect(subject.calculate("María", "Gutierrez López")).to eq("gutierrez lopez maria")
    end

  end
end
