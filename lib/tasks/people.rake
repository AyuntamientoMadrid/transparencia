namespace :people do
  desc 'touches all people (forces recalculations on save)'
  task touch: :environment do
    Person.find_each do |p|
      p.save
    end
  end

  desc "migrates existing portraits to paperclip objects"
  task migrate_portraits: :environment do
    Person.find_each do |person|
      image_path = "#{Rails.root}/app/assets/images/people/#{person.friendly_id}.jpg"

      if File.exists?(image_path)
        person.update(portrait: File.new(image_path))
      else
        puts "No existing image available for #{person.name}; skipping"
      end
    end
  end
end
