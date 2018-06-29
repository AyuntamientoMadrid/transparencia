module PeopleHelper

  def profile_picture(person, size = nil)
    image_tag person.portrait.url(size || :medium), alt: person.name
  end

  def people_job_level_options_for_select(current_job_level)
    array = Person.job_levels.map{|j| [I18n.t("people.job_levels.#{j}"), j]}
    options_for_select(array, current_job_level)
  end

  def breadcrumb_person_title_link(person)
    if person.councillor?
      link_to t("people.councillors.title"), councillors_people_path
    elsif person.director?
      link_to t("people.directors.title"), directors_people_path
    elsif person.temporary_worker?
      link_to t("people.temporary_workers.title"), temporary_workers_people_path
    elsif person.public_worker?
      link_to t("people.public_workers.title"), public_workers_people_path
    elsif person.spokesperson?
      link_to t("people.spokespeople.title"), spokespeople_people_path
    elsif person.labour?
      link_to t("people.labours.title"), labours_people_path
    end
  end

end
