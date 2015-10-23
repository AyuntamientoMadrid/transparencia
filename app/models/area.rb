class Department < ActiveRecord::Base
  has_many  :departments
  
end