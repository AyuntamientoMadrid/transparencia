class Subvention < ActiveRecord::Base
  include PgSearch

  pg_search_scope :pg_search, {
    against: [
      :recipient,
      :project,
      :kind,
      :location,
      :year
    ],
    using: {
      tsearch: { dictionary: "spanish" }
    },
    ignoring: :accents
  }

  def self.search(query)
    self.pg_search(query)
  end
end
