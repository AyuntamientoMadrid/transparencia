require 'profile_exporter'
require 'fileutils'

namespace :export do
  desc "Exports profiles to public/export/profiles.csv & public/export/profiles.xls"
  task profiles: :environment do
    folder = Rails.root.join('public/export')
    FileUtils.rm_rf folder
    FileUtils.mkdir_p folder

    exporter = ProfileExporter.new

    exporter.save_csv(folder.join('profiles.csv'))
    exporter.save_xls(folder.join('profiles.xls'))
  end

end
