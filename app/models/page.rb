class Page < ActiveRecord::Base
  belongs_to :parent, class_name: "Page", foreign_key: "parent_id"
  has_many :pages, class_name: "Page", foreign_key: "parent_id"

  validates_presence_of :title
  validates_format_of :link, 
    with: URI::regexp(%w(http https)), 
    message: "el enlace introducido no es válido", 
    allow_blank: true
  validate :link_xor_content 
  
  def level
    self.parent.present? ? self.parent.level + 1 : 1
  end

  def is_page?
    self.is_link? || self.is_content?
  end

  def is_link?
    !self.link.blank?
  end
  
  def is_content?
    !self.content.blank?
  end

  def link_xor_content
    if self.link.present? && self.content.present?
      errors.add(:link, "no puede crear una página que contenga un enlace externo y contentido. Rellene sólo uno de los dos campos.")
    end
  end

end