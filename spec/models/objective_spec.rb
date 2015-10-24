require 'rails_helper'

describe Objective do

  let!(:objective)  { build(:objective) }

  it 'should be valid' do
    expect(objective).to be_valid
  end

  it 'should not be valid without title' do
    objective.update(title: nil)
    expect(objective).not_to be_valid
  end

  it 'should not be valid without description' do
    objective.update(description: nil)
    expect(objective).not_to be_valid
  end  

  describe 'scopes' do 
    let!(:accomplished_objective)     { create(:objective, accomplished: true) }
    let!(:not_accomplished_objective) { create(:objective) }

    it 'accomplished scopes should return accomplished objectives' do
      expect(Objective.accomplished.count).to eq(1)
      expect(Objective.accomplished).to eq [accomplished_objective]
      expect(Objective.accomplished.first.accomplished).to be_truthy
    end

    it 'no-accomplished scopes should return no-accomplished objectives' do
      expect(Objective.not_accomplished.count).to eq(1)    
      expect(Objective.not_accomplished).to eq [not_accomplished_objective]
      expect(Objective.not_accomplished.first.accomplished).to be_falsy
    end
  end

end