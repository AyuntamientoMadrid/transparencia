class Page < ActiveRecord::Base
  belongs_to :parent, class_name: "Page", foreign_key: "parent_id"
  has_many :pages, class_name: "Page", foreign_key: "parent_id"

  def level
    self.parent.present? ? self.parent.level + 1 : 1
  end

  def childs
  	Page.all.where(parent_id: self.id)
  end

end