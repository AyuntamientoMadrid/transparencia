class SearchesController < ApplicationController

  def index
    @results = Search.new(params[:query]).results
  end

end