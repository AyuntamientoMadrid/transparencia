module PeopleHelper

  def people_job_level_options_for_select(current_job_level)
    array = [['','']] + Person.job_levels.map{|j| [I18n.t("people.job_levels.#{j}"), j]}
    options_for_select(array, current_job_level)
  end


end
