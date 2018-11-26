require "rails_helper"
require "rake"

describe "People tasks" do
  before do
    Rake.application.rake_require "tasks/people"
    Rake::Task.define_task(:environment)
  end

  describe "#migrate_portraits" do
    let :run_rake_task do
      Rake::Task["people:migrate_portraits"].reenable
      Rake.application.invoke_task "people:migrate_portraits"
    end

    context "Existing image" do
      let!(:person) { create(:person, first_name: "Pablo", last_name: "Soto Bravo") }

      it "attaches the image" do
        run_rake_task
        person.reload

        expect(person.portrait).to be_present
      end

      it "updates the person" do
        expect { run_rake_task }.to change { person.reload.updated_at }
      end
    end

    context "Non-existing image" do
      let!(:person) { create(:person, first_name: "Red", last_name: "Richards") }

      it "doesn't attach the image" do
        run_rake_task
        person.reload

        expect(person.portrait).not_to be_present
      end
    end
  end
end

