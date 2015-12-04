PgSearch.multisearch_options = {
  using: {
    tsearch: { dictionary: "spanish", any_word: true },
    trigram: { threshold: 0.1 },
  },
  ignoring: :accents
}