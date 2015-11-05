class Admin::StatsController < Admin::BaseController

  def show
    @event_types = Ahoy::Event.group(:name).count
    @visits = Visit.count
  end

end
