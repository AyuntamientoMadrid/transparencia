require 'stringio'
require 'logger'
require 'excel_importers/profile'

class Admin::ProfileUploadsController < Admin::BaseController
  def new
  end

  def create
    file = profile_upload_params[:file].tempfile

    @log = StringIO.open do |strio|
      logger = Logger.new(strio)
      logger.formatter = proc do |severity, _datetime, _progname, msg|
        "#{severity}: #{msg}\n"
      end

      importer = ExcelImporters::Profile.new file,
                                             header_field: "Fecha",
                                             logger: logger
      if importer.safe_import!
        flash[:notice] = t('admin.profile_uploads.create.no_errors')
      else
        flash[:alert] = t('admin.profile_uploads.create.errors')
      end

      logger.close
      strio.string
    end

    render :show
  end

  private

    def profile_upload_params
      params.require(:profile_upload).permit(:file)
    end
end
