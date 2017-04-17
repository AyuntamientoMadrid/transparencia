require 'stringio'
require 'logger'
require 'excel_importers/profile'

class Admin::ProfileUploadsController < Admin::BaseController
  def new
    @profile_upload = ProfileUpload.new
  end

  def index
    @profile_uploads = ProfileUpload.all.order(created_at: :desc).page(params[:page])
  end

  def create
    attrs = profile_upload_params.merge(author: current_administrator,
                                        check_for_file: true)
    @profile_upload = ProfileUpload.new(attrs)

    if @profile_upload.valid?
      StringIO.open do |strio|
        logger = Logger.new(strio)
        logger.formatter = proc do |severity, _datetime, _progname, msg|
          "#{severity}: #{msg}\n"
        end

        importer = ExcelImporters::Profile.new @profile_upload.file.tempfile,
                                               header_field: 'Fecha',
                                               logger: logger
        successful = true
        if importer.safe_import!
          flash[:notice] = t('admin.profile_uploads.create.no_errors')
        else
          successful = false
          flash[:alert] = t('admin.profile_uploads.create.errors')
        end

        logger.close

        @profile_upload.assign_attributes(
          file_format: importer.file_format,
          original_filename: @profile_upload.file.try(:original_filename),
          log: strio.string,
          successful: successful
        )
      end

      @profile_upload.save!
      redirect_to admin_profile_upload_path(@profile_upload)
    else
      render :new
    end
  end

  def show
    @profile_upload= ProfileUpload.find(params[:id])
  end

  private

    def profile_upload_params
      params.require(:profile_upload).permit(:file)
    end
end
