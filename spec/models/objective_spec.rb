require 'rails_helper'

describe Objective do

  let!(:objective)  { build(:objective) }

  it 'factory should be valid' do
    expect(objective).to be_valid
  end

  it 'without title should be invalid' do
    objective.update(title: nil)
    expect(objective).not_to be_valid
  end

  it 'without description should be invalid' do
    objective.update(description: nil)
    expect(objective).not_to be_valid
  end  

  describe 'scopes' do 
    let!(:accomplished_objective)     { create(:objective) }
    let!(:no_accomplished_objective)  { create(:objective, accomplished: false) }

    it 'accomplished scopes should return accomplished objectives' do
      expect(Objective.accomplished.count).to eq(1)
      expect(Objective.accomplished.first.accomplished).to be_truthy
    end

    it 'no-accomplished scopes should return no-accomplished objectives' do
      expect(Objective.not_accomplished.count).to eq(1)      
      expect(Objective.not_accomplished.first.accomplished).to be_falsy
    end
  end

end