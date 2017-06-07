module Sortable
  extend ActiveSupport::Concern

  included do
    helper_method :sort_column, :sort_direction
  end

  private

    def sort_column
      resource_model.column_names.include?(params[:sort]) ? params[:sort] : ""
    end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : ""
  end

  def sort_options
    return default_order if params[:sort].blank?
    clean(sort_column) + " " + sort_direction
  end

  def clean(column)
    type_of(column) == :string ? "LOWER(unaccent(#{column}))" : column
  end

  def type_of(column)
    resource_model.column_for_attribute(column).type
  end

end