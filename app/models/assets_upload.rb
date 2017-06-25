class AssetsUpload < FileUpload
  validates :period, presence: true
end
