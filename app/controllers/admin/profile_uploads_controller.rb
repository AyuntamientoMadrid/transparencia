require 'stringio'
require 'logger'
require 'excel_importers/profile'

class Admin::ProfileUploadsController < Admin::BaseController
  def new
  end

  def create
    file =  profile_upload_params[:file].tempfile

    @log = StringIO.open do |strio|
      logger = Logger.new(strio)
      logger.formatter = proc do |severity, datetime, progname, msg|
        "#{severity}: #{msg}\n"
      end

      importer = ExcelImporters::Profile.new file,
                                             headers_row: 2,
                                             logger: logger
      if importer.safe_import!
        flash[:notice] = t('admin.profile_uploads.create.no_errors')
      else
        flash[:error] = t('admin.profile_uploads.create.errors')
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
