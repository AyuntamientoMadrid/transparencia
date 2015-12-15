module PeopleHelper

  def profile_picture(person)
    image_tag "people/#{person.friendly_id}.jpg", alt: person.name
  end

  def name_initial(person)
    ActiveSupport::Inflector.transliterate(person.name[0]).upcase
  end
end
