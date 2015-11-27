require 'rails_helper'

describe ActivitiesDeclaration do

  describe 'Data accesors' do
    it 'should retrieve public_activities data from hstore' do
      declaration = create(:activities_declaration, data: { public_activities: [{'entity' => 'X', 'position' => 'Y' }]})
      activity = declaration.public_activities.first
      expect(activity.entity).to eq('X')
      expect(activity.position).to eq('Y')
    end

    it 'should retrieve private_activities data from hstore' do
      declaration = create(:activities_declaration, data: { private_activities: [{'kind' => 'A', 'entity' => 'B', 'position' => 'C' }]})
      activity = declaration.private_activities.first
      expect(activity.kind).to eq('A')
      expect(activity.entity).to eq('B')
      expect(activity.position).to eq('C')
    end

    it 'should retrieve other_activities data from hstore' do
      declaration = create(:activities_declaration, data: { other_activities: [{'description' => 'W' }]})
      activity = declaration.other_activities.first
      expect(activity.description).to eq('W')
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

    it 'adds private activities to data' do
      declaration = create(:activities_declaration)
      declaration.add_private_activity('Private', 'Very Private', 'Entity', 'Position', '1/1/2016', '1/1/2017')

      private_activity = declaration.private_activities.last
      expect(private_activity.kind).to eq 'Private'
      expect(private_activity.description).to eq 'Very Private'
      expect(private_activity.entity).to eq 'Entity'
      expect(private_activity.position).to eq 'Position'
      expect(private_activity.start_date).to eq Date.parse('1/1/2016')
      expect(private_activity.end_date).to eq Date.parse('1/1/2017')
    end

    it 'adds other activities to data' do
      declaration = create(:activities_declaration)
      declaration.add_other_activity('Other things', '2/2/2016', '2/2/2017')

      other_activity = declaration.other_activities.last
      expect(other_activity.description).to eq 'Other things'
      expect(other_activity.start_date).to eq Date.parse('2/2/2016')
      expect(other_activity.end_date).to eq Date.parse('2/2/2017')
    end
  end

end