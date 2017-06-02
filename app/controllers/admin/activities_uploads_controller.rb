require 'stringio'
require 'logger'
require 'excel_importers/activities'

class Admin::ActivitiesUploadsController < Admin::BaseController
  def new
    @activities_upload = ActivitiesUpload.new
  end

  def index
    @activities_uploads = ActivitiesUpload.all.order(created_at: :desc).page(params[:page])
  end

  def create
    attrs = activities_upload_params.merge(author: current_administrator,
                                        check_for_file: true)
    @activities_upload = ActivitiesUpload.new(attrs)

    if @activities_upload.valid?
      StringIO.open do |strio|
        logger = ExcelImporters::Base.newDefaultLogger(strio)
        importer = ExcelImporters::Activities.new @activities_upload.file.tempfile,
                                                  @activities_upload.period,
                                                  logger
        successful = true
        if importer.import
          flash[:notice] = t('admin.activities_uploads.create.no_errors')
        else
          successful = false
          flash[:alert] = t('admin.activities_uploads.create.errors')
        end

        logger.close

        @activities_upload.assign_attributes(
          file_format: :xls,
          original_filename: @activities_upload.file.try(:original_filename),
          log: strio.string,
          successful: successful
        )
      end

      @activities_upload.save!
      redirect_to admin_activities_upload_path(@activities_upload)
    else
      render :new
    end
  end

  def show
    @activities_upload = ActivitiesUpload.find(params[:id])
  end

  private

    def activities_upload_params
      params.require(:activities_upload).permit(:file, :period)
    end
end
