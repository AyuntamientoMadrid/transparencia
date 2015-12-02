class SubventionsController < ApplicationController

  def index
    @subventions = Subvention.all.order(year: :desc)
  end

end