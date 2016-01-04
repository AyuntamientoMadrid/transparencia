class Admin::BaseController < ApplicationController

  before_action :authenticate_administrator!

  layout 'admin'

  private

    def full_feature?
      true
    end

end
