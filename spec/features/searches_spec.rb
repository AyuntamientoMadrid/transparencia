require 'rails_helper'

feature 'Search' do

  scenario 'Results' do
    jobs_page = Page.create(title: "List of jobs")

    visit home_path
    fill_in :query, with: 'Jobs'
    click_button 'Search'

    expect(page).to have_content("Found 1 result")
    expect(page).to have_content("List of jobs")
    expect(page).to have_css(".result", count: 1)

    click_link "List of jobs"
    expect(current_url).to eq(page_url(jobs_page))
  end

  scenario 'No results' do
    visit home_path
    fill_in :query, with: 'Jobs'
    click_button 'Search'

    expect(page).to have_content("No results found")
    expect(page).to have_css(".result", count: 0)
  end

end