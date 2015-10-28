require 'rails_helper'

describe PagesHelper do

  let!(:page1)  { create(:page) }
  let!(:page2)  { create(:page, parent: page1) }
  let!(:page3)  { create(:page, parent: page2) }
  let!(:page4)  { create(:page, parent: page3) }

  describe "prefix" do

  end

  describe "select options for pages" do

  end  

end