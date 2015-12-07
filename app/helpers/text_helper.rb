module TextHelper
  def format_free_text(text)
    simple_format Rinku.auto_link(text, :all, 'target="_blank" rel="nofollow"')
  end
end
