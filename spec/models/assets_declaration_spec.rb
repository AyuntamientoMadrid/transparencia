require "rails_helper"

describe AssetsDeclaration do
  it "expires the cache when updated" do
    declaration = create(:assets_declaration)

    expect { declaration.update(declaration_date: 1.day.ago) }.to change { declaration.cache_key }
  end
end
