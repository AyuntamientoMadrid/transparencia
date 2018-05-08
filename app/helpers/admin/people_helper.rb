module Admin
  module PeopleHelper

    def public_activities_list(declaration)
      list = declaration.public_activities
      list.empty? ? [empty_public_activity] : list
    end

    def activities_declarations_list
      @person.activities_declarations.all << @person.activities_declarations.build
    end

    def empty_public_activity
      OpenStruct.new(entity: nil, position: nil, start_date: nil, end_date: nil)
    end

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