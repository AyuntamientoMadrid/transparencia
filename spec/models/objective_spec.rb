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

end