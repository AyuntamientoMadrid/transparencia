class AddJobLevelToPeople < ActiveRecord::Migration
  def change
    add_column :people, :job_level, :string
  end
end
