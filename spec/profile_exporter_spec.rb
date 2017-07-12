require 'rails_helper'
require 'profile_exporter'

describe ProfileExporter do
  let(:exporter) { ProfileExporter.new }

  describe '#headers' do
    it "generates localized headers" do
      expect(exporter.headers.first).to eq('Id number')
      expect(exporter.headers.last).to eq('Job level code')
    end
  end

  describe '#person_to_row' do
    it "generates a row of info based on a person" do
      p = create(:person, first_name: 'James T.', last_name: 'Kirk')
      p.add_study('Officer Training Program', 'Starfleet Academy', 2252, 2257)
      p.add_course('Ancient Literature', "John Gill's class", 2253, 2253)
      p.add_language('Inglés', 'Legendary')
      p.add_language('Klingon', 'jIyaj')
      p.add_public_job('Starfleet captain', 'Starfleet', 2265, 2270)
      p.add_private_job('Gorn Tamer', 'Metron Arena', 2266, 2266)
      p.publications = "Captain's Log"

      row = exporter.person_to_row(p)

      expect(row).to include('Officer Training Program', 'Starfleet Academy', 2252, 2257)
      expect(row).to include('Ancient Literature', "John Gill's class", 2253, 2253)
      expect(row).to include('Legendary')
      expect(row).to include('Klingon', 'jIyaj')
      expect(row).to include('Starfleet captain', 'Starfleet', 2265, 2270)
      expect(row).to include('Gorn Tamer', 'Metron Arena', 2266, 2266)
      expect(row).to include("Captain's Log")
    end
  end

end
