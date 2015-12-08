class Contract < ActiveRecord::Base
  include PgSearch

  pg_search_scope :pg_search, {
    against: [
      :center,
      :organism,
      :contract_number,
      :document_number,
      :description,
      :kind,
      :award_procedure,
      :award_criteria,
      :recipient,
      :recipient_document_number
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
