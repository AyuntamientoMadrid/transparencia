class PeopleController < ApplicationController

  def index
    @people = Person.all.includes(:party)
  end

  def show
    @person = Person.find(params[:id])
  end

end
