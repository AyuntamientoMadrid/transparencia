namespace :people do
  desc 'touches all people (forces recalculations on save)'
  task touch: :environment do
    Person.find_each do |p|
      p.save
    end
  end
end
