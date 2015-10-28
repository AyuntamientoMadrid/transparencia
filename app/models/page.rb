class Page < ActiveRecord::Base
  has_ancestry

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

  def self.arrange_as_array(options={}, hash=nil)                                                                                                                                                            
    hash ||= arrange(options)

    arr = []
    hash.each do |node, children|
      arr << node
      arr += arrange_as_array(options, children) unless children.nil?
    end
    arr
  end

  def name_for_selects
    "#{'--' * depth} #{title}"
  end

  def possible_parents
    parents = Page.arrange_as_array(:order => 'title')
    return new_record? ? parents : parents - subtree
  end  

end