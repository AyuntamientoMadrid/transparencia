module SocialHelper
  def twitter_url(handle)
    "https://twitter.com/#{handle.gsub('@', '')}"
  end

  def facebook_url(handle)
    handle = handle.gsub('https://', '')
                   .gsub('http://', '')
                   .gsub('www.facebook.com/', '')
                   .gsub('facebook.com/', '')
    "https://www.facebook.com/#{handle}"
  end
end
