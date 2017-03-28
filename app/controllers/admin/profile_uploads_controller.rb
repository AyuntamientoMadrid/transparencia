class Admin::ProfileUploadsController < Admin::BaseController

  def new

  end

  def create
    render text: params.inspect
  end

  def show

  end

end
