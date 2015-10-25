require 'rails_helper'

describe PagesHelper do

  let!(:page1)  { create(:page) }
  let!(:page2)  { create(:page, parent: page1) }
  let!(:page3)  { create(:page, parent: page2) }
  let!(:page4)  { create(:page, parent: page3) }

  describe "prefix" do

    it "should return empty prefix for first level pages" do
      expect(prefix(page1.level)).to eq(prefix(1))
    end

    it "should return empty prefix for first level pages" do
      expect(prefix(page2.level)).to eq(prefix(2))
    end

    it "should return empty prefix for first level pages" do
      expect(prefix(page3.level)).to eq(prefix(3))
    end

    it "should return empty prefix for first level pages" do
      expect(prefix(page4.level)).to eq(prefix(4))
    end
  end

  describe "select options for pages" do

    it "should return indented options" do
      options = [
        ["#{prefix(1)}#{page1.title}", page1.id],
        ["#{prefix(2)}#{page2.title}", page2.id],
        ["#{prefix(3)}#{page3.title}", page3.id]
      ]
      expect(pages_options_for_select).to eq(options)
    end

  end  

end