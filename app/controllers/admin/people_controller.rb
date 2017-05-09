class Admin::PeopleController < Admin::BaseController

  def index
    @people = Person.where('people.hidden_at IS NOT NULL').order(:role, :last_name, :first_name)
  end
end
