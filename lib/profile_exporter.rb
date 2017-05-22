class ProfileExporter
  FIELDS = %w{
    profiled_at
    first_name
    last_name
    role
    unit
    twitter
    facebook

    first_study_description
    first_study_entity
    first_study_start_year
    first_study_end_year
    second_study_description
    second_study_entity
    second_study_start_year
    second_study_end_year
    third_study_description
    third_study_entity
    third_study_start_year
    third_study_end_year
    fourth_study_description
    fourth_study_entity
    fourth_study_start_year
    fourth_study_end_year
    studies_comment

    first_course_description
    first_course_entity
    first_course_start_year
    first_course_end_year
    second_course_description
    second_course_entity
    second_course_start_year
    second_course_end_year
    third_course_description
    third_course_entity
    third_course_start_year
    third_course_end_year
    fourth_course_description
    fourth_course_entity
    fourth_course_start_year
    fourth_course_end_year
    courses_comment

    language_english_level
    language_french_level
    language_german_level
    language_italian_level
    language_other_name
    language_other_level

    public_jobs_body
    public_jobs_start_year

    first_public_job_description
    first_public_job_entity
    first_public_job_start_year
    first_public_job_end_year
    second_public_job_description
    second_public_job_entity
    second_public_job_start_year
    second_public_job_end_year
    third_public_job_description
    third_public_job_entity
    third_public_job_start_year
    third_public_job_end_year
    fourth_public_job_description
    fourth_public_job_entity
    fourth_public_job_start_year
    fourth_public_job_end_year

    public_jobs_level

    first_private_job_description
    first_private_job_entity
    first_private_job_start_year
    first_private_job_end_year
    second_private_job_description
    second_private_job_entity
    second_private_job_start_year
    second_private_job_end_year
    third_private_job_description
    third_private_job_entity
    third_private_job_start_year
    third_private_job_end_year
    fourth_private_job_description
    fourth_private_job_entity
    fourth_private_job_start_year
    fourth_private_job_end_year

    career_comment

    first_political_post_description
    first_political_post_entity
    first_political_post_start_year
    first_political_post_end_year
    second_political_post_description
    second_political_post_entity
    second_political_post_start_year
    second_political_post_end_year
    third_political_post_description
    third_political_post_entity
    third_political_post_start_year
    third_political_post_end_year
    fourth_political_post_description
    fourth_political_post_entity
    fourth_political_post_start_year
    fourth_political_post_end_year

    political_posts_comment

    publications

    teaching_activity

    special_mentions

    other
  }

  def headers
    FIELDS.map { |f| I18n.t("profile_exporter.#{f}") }
  end

  def person_to_row(person)
    FIELDS.map do |f|
      person.send(f)
    end
  end

  def windows_headers
    windows_array headers
  end

  def windows_person_row(person)
    windows_array person_to_row(person)
  end

  def save_csv(path)
    CSV.open(path, 'w', col_sep: ';', force_quotes: true, encoding: "ISO-8859-1") do |csv|
      csv << windows_headers
      Person.working.unhidden.find_each do |person|
        csv << windows_person_row(person)
      end
    end
  end

  def save_xls(path)
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet
    sheet.row(0).default_format = Spreadsheet::Format.new color: :blue, weight: :bold
    sheet.row(0).concat headers
    index = 1
    Person.working.unhidden.find_each do |person|
      sheet.row(index).concat person_to_row(person)
      index += 1
    end

    book.write(path)
  end

  private
    def windows_array(values)
      values.map{|v| v.to_s.encode("ISO-8859-1", invalid: :replace, undef: :replace, replace: '')}
    end
end
