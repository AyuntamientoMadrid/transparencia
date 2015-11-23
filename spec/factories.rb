require 'securerandom'

FactoryGirl.define do

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

  factory :ahoy_event, :class => Ahoy::Event do
    id { SecureRandom.uuid }
    time DateTime.now
    sequence(:name) {|n| "Event #{n} type"}
  end

  factory :visit  do
    id { SecureRandom.uuid }
    started_at DateTime.now
  end

end
