# For more options http://norman.github.io/friendly_id/file.Guide.html:

FriendlyId.defaults do |config|
  # Some words could conflict with Rails's routes when used as slugs, or are undesirable to allow as slugs.
  config.use :reserved
  config.reserved_words = %w(new edit index session login logout users admin stylesheets assets javascripts images)
end
