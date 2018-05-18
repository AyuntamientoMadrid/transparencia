module Admin
  module PeopleHelper

    def activities_declarations_tab_name(declaration)
      declaration.declaration_date ||
        declaration.changes['declaration_date'].try(:first) ||
        t('shared.add')
    end

    def public_activities_list(declaration)
      list = declaration.public_activities
      list.empty? ? [empty_public_activity] : list
    end

    def private_activities_list(declaration)
      list = declaration.private_activities
      list.empty? ? [empty_private_activity] : list
    end

    def other_activities_list(declaration)
      list = declaration.other_activities
      list.empty? ? [empty_other_activity] : list
    end

    def empty_other_activity
      OpenStruct.new(description: nil, start_date: nil, end_date: nil)
    end

    def empty_public_activity
      OpenStruct.new(entity: nil, position: nil, start_date: nil, end_date: nil)
    end

    def empty_private_activity
      OpenStruct.new(kind: nil, description: nil, entity: nil,
                     position: nil, start_date: nil, end_date: nil)
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