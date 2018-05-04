module Admin
  module PeopleHelper

    def empty_study
      OpenStruct.new(description: nil, entity: nil, start_year: nil, end_year: nil)
    end

    def empty_course
      OpenStruct.new(description: nil, entity: nil, start_year: nil, end_year: nil)
    end

    def empty_language
      OpenStruct.new(name: nil, level: nil)
    end

    def empty_public_job
      OpenStruct.new(description: nil, entity: nil, start_year: nil, end_year: nil)
    end

    def empty_private_job
      OpenStruct.new(description: nil, entity: nil, start_year: nil, end_year: nil)
    end

    def empty_political_post
      OpenStruct.new(description: nil, entity: nil, start_year: nil, end_year: nil)
    end

  end
end