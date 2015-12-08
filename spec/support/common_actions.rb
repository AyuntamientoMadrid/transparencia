module CommonActions

  def submit_form
    find('input[name="commit"]').click
  end

  def search(query)
    Search.new(query).results.map(&:searchable)
  end

end
