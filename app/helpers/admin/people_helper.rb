module Admin
  module PeopleHelper

    def real_estate_properties_list(declaration)
      list = declaration.real_estate_properties
      list.empty? ? [empty_real_estate_property] : list
    end

    def activities_declarations_tab_name(declaration)
      declaration.declaration_date ||
        declaration.changes['declaration_date'].try(:first) ||
        t('shared.add')
    end

    def assets_declarations_tab_name(declaration)
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

    def account_deposits_list(declaration)
      list = declaration.account_deposits
      list.empty? ? [empty_account_deposit] : list
    end

    def other_deposits_list(declaration)
      list = declaration.other_deposits
      list.empty? ? [empty_other_deposit] : list
    end

    def vehicles_list(declaration)
      list = declaration.vehicles
      list.empty? ? [empty_vehicle] : list
    end

    def empty_vehicle
      OpenStruct.new(kind: nil, model: nil, purchase_date: nil)
    end

    def empty_account_deposit
      OpenStruct.new(kind: nil, banking_entity: nil, balance: nil)
    end

    def empty_real_estate_property
      OpenStruct.new(kind: nil, type: nil, description: nil, municipality: nil,
                     share: nil, purchase_date: nil, tax_value: nil, notes: nil)
    end

    def empty_other_deposit
      OpenStruct.new(kind: nil, description: nil, amount: nil, purchase_date: nil)
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