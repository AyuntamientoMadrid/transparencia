FactoryGirl.define do
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

end