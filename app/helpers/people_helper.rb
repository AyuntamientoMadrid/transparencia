module PeopleHelper

  def profile_picture(person)
    image_tag "people/#{person.friendly_id}.jpg", alt: person.name
  end
end
