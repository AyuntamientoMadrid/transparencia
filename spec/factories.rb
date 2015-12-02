require 'securerandom'

FactoryGirl.define do

  factory :subvention do
    sequence(:recipient) { |n| "NGO#{n}" }
    project  'Water management'
    kind     'Development'
    location 'Madrid'
    year 2016
    amount_euro_cents 100
  end


  factory :person do
    sequence(:name) { |n| "person#{n}" }
    sequence(:email) { |n| "person#{n}@madrid.es" }
    sequence(:gender) { "female" }
    sequence(:role) { "major" }
    biography { "biography" }
    party
  end

  factory :party do
    sequence(:name) { |n| "party#{n}" }
    logo { 'logo.png' }
  end

  factory :activities_declaration do
    person
    declaration_date DateTime.now
  end

  factory :administrator do
    sequence(:email) { |n| "admin#{n}@madrid.es" }
    password         '12345678'
  end

  factory :area do
    sequence(:name) { |n| "Area#{n}" }
  end

  factory :department do
    sequence(:name) { |n| "Department#{n}" }
    description   'Department description'
    directives    'Directives text'
    area
  end

  factory :objective do
    sequence(:title) { |n| "Objective#{n}" }
    sequence(:order) { |n| n }
    description   'Objective description'
    department
  end

  factory :page do
    sequence(:title)  { |n| "Page title #{n}" }
  end

end
