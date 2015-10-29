class PeopleController < ApplicationController

  def index
    @people = [
      Person.new("Pablo Soto",
                 :male,
                 "Concejal",
                 "1000",
                 "Ahora Madrid"),
      Person.new("Manuela Carmena",
                 :female,
                 "Alcaldesa",
                 "1000",
                 "Ahora Madrid")
    ]
  end

  def show
    @person = Person.new("Pablo Soto",
                         :male,
                         "Concejal",
                         "1000",
                         "Ahora Madrid")
  end

end
