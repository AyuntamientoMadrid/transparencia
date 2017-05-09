class FileUpload < ActiveRecord::Base
  belongs_to :author, class_name: 'Administrator'

  validates :author, presence: true
  validates :file, presence: true, if: :check_for_file

  attr_accessor :check_for_file
  attr_accessor :file

  def author_email
    author.try(:email)
  end

  def translated_successful
    I18n.t("shared.#{successful}")
  end
end
