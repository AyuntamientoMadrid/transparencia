class Entity < ActiveRecord::Base
  has_many  :objectives
  belongs_to  :area
end