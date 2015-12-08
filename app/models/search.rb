class Search
  attr_accessor :query

  def initialize(query)
    @query = query
  end

  def results
    PgSearch.multisearch(@query)
  end

end