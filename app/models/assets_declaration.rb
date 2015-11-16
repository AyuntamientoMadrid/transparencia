class AssetsDeclaration < ActiveRecord::Base

  belongs_to :person

  validates :start_date, presence: true

end
