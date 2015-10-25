class Page < ActiveRecord::Base
  belongs_to :parent, class_name: "Page", foreign_key: "parent_id"
  
end