module Sortable
  extend ActiveSupport::Concern

  included do
    helper_method :sort_column, :sort_direction
  end

  private

  def sort_column
    Subvention.column_names.include?(params[:sort]) ? params[:sort] : "year"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  def sort_options
    clean(sort_column) + " " + sort_direction
  end

  def clean(column)
    type_of(column) == :string ? "LOWER(unaccent(#{column}))" : column
  end

  def type_of(column)
    Subvention.column_for_attribute(column).type
  end

end