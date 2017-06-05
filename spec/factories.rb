require 'securerandom'

FactoryGirl.define do

  factory :contract do
    sequence(:recipient) { |n| "Johnson#{n}" }
    description 'sample description'
    organism    'Health'
    awarded_at  Date.today
    award_amount_cents 100
  end

  factory :subvention do
    sequence(:recipient) { |n| "NGO#{n}" }
    project  'Water management'
    kind     'Development'
    location 'Madrid'
    year 2016
    amount_cents 100
  end

  factory :person do
    sequence(:first_name) { |n| "person#{n}" }
    sequence(:last_name) { |n| "surname#{n}" }
    sequence(:email) { |n| "person#{n}@madrid.es" }
    sequence(:role) { "major" }
    job_level { 'councillor' }
    party
  end

  factory :director, parent: :person do
    job_level { 'director' }
  end

  factory :temporary_worker, parent: :person do
    job_level { 'temporary_worker' }
  end

  factory :party do
    sequence(:name) { |n| "party#{n}" }
    logo { 'logo.png' }
  end

  factory :activities_declaration do
    person
    declaration_date DateTime.now
  end

  factory :assets_declaration do
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

  factory :profile_upload do
    association :author, factory: :administrator
  end

  factory :activities_upload do
    association :author, factory: :administrator
    period { 'inicial' }
  end

end
