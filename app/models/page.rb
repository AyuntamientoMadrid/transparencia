class Page < ActiveRecord::Base
  include PgSearch
  has_ancestry

  validates_presence_of :title
  validates_format_of :link, 
    with: URI::regexp(%w(http https)), 
    message: "el enlace introducido no es válido", 
    allow_blank: true
  validate :link_or_content

  multisearchable against: [:title, :subtitle, :content]

  def level
    self.depth + 1
  end

  def is_page?
    self.is_link? || self.is_content?
  end

  def is_link?
    self.link.present?
  end
  
  def is_content?
    self.content.present?
  end

  def link_or_content
    if self.link.present? && self.content.present?
      errors.add(:link, "no puede crear una página que contenga un enlace externo y contenido. Rellene sólo uno de los dos campos.")
    end

    if self.depth == 3 && self.link.blank? && self.content.blank?
      errors.add(:link, "tiene que añadir un enlace externo o contenido a la página. Rellene uno de los dos campos.")
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