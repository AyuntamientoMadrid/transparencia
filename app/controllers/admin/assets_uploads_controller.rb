require 'stringio'
require 'logger'
require 'excel_importers/assets'
include DeclarationsHelper

class Admin::AssetsUploadsController < Admin::BaseController
  def new
    @assets_upload = AssetsUpload.new
    @periods_list = DeclarationsHelper.periods_list
  end

  def index
    @assets_uploads = AssetsUpload.all.order(created_at: :desc).page(params[:page])
  end

  def create
    attrs = assets_upload_params.merge(author: current_administrator,
                                       check_for_file: true)
    @assets_upload = AssetsUpload.new(attrs)

    if @assets_upload.valid?
      StringIO.open do |strio|
        logger = ExcelImporters::Base.new_default_logger(strio)
        importer = ExcelImporters::Assets.new @assets_upload.file.tempfile,
                                              @assets_upload.period,
                                              logger
        successful = true
        if importer.import
          flash[:notice] = t('admin.assets_uploads.create.no_errors')
        else
          successful = false
          flash[:alert] = t('admin.assets_uploads.create.errors')
        end

        logger.close

        @assets_upload.assign_attributes(
          file_format: :xls,
          original_filename: @assets_upload.file.try(:original_filename),
          log: strio.string,
          successful: successful
        )
      end

      @assets_upload.save!
      redirect_to admin_assets_upload_path(@assets_upload)
    else
      render :new
    end
  end

  def show
    @assets_upload = AssetsUpload.find(params[:id])
  end

  private

    def assets_upload_params
      params.require(:assets_upload).permit(:file, :period)
    end
end
