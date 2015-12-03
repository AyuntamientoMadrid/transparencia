require 'rails_helper'

describe StaticPagesController do

  describe 'Static pages' do
    it 'should include a privacy page' do
      get :privacy
      expect(response).to be_ok
    end

    it 'should include a conditions page' do
      get :conditions
      expect(response).to be_ok
    end

    it 'should include a accessibility page' do
      get :accessibility
      expect(response).to be_ok
    end
  end

end
