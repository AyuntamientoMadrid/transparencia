require 'rails_helper'

describe ActivitiesDeclaration do

  describe 'Data accesors' do
    it 'public_activities should retrieve public_activities data from hstore' do
      declaration = create(:activities_declaration, data: { public_activities: [{'entity' => 'X', 'position' => 'Y' }]})
      activity = declaration.public_activities.first
      expect(activity.entity).to eq('X')
      expect(activity.position).to eq('Y')
    end
  end

  describe 'Adding hstore data' do
    it 'adds public activities to data' do
      declaration = create(:activities_declaration)
      declaration.add_public_activity('Entity', 'Position', '1/1/2015', '1/1/2016')

      public_activity = declaration.public_activities.last
      expect(public_activity.entity).to eq 'Entity'
      expect(public_activity.position).to eq 'Position'
      expect(public_activity.start_date).to eq Date.parse('1/1/2015')
      expect(public_activity.end_date).to eq Date.parse('1/1/2016')
    end
  end

end