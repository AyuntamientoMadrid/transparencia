class Page < ActiveRecord::Base
  belongs_to :parent, class_name: "Page", foreign_key: "parent_id"

  def level
    return 1 if self.parent.blank?
    return 2 if self.parent.present? && self.parent.parent.blank?
    return 3 if self.parent.present? && self.parent.parent.present? && self.parent.parent.parent.blank?
    return 0
  end 
end