class ActivitiesUpload < FileUpload
  validates :period, presence: true
end
