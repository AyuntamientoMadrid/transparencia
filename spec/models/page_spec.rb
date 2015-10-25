require 'rails_helper'

feature Page do

  let!(:page)  { build(:page) }

  it 'should be valid' do
    expect(page).to be_valid
  end

  describe "level" do
    let!(:page1)  { create(:page) }
    let!(:page2)  { create(:page, parent: page1) }
    let!(:page3)  { create(:page, parent: page2) }
    let!(:page4)  { create(:page, parent: page3) }

    it 'should return 1 for root nodes' do
      expect(page1.level).to eq(1)
    end

    it 'should return 1 for root nodes' do
      expect(page2.level).to eq(2)
    end 

    it 'should return 1 for root nodes' do
      expect(page3.level).to eq(3)
    end 

    it 'should return 1 for root nodes' do
      expect(page4.level).to eq(4)
    end             
  end 

end