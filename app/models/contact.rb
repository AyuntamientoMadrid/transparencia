class Contact
  include ActiveModel::Model
  extend ActiveModel::Translation

  attr_accessor :name, :email, :body, :person

  validates :person, :name, :email, :body, presence: true
  validates :email, format: Devise.email_regexp
end
