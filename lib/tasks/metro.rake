namespace :metro do
  desc "Import metro data for all existing agencies"
  task :import, [:gtfs_endpoint] => [:environment] do |t, args|
    ActiveRecord::Base.logger.silence do
      agency = Agency.find_or_create_by(gtfs_endpoint: args[:gtfs_endpoint])
      Metro::Importer.new(agency, logger: Logger.new(STDOUT)).import!
    end
  end

  desc "Import metro data for a new agency"
  task import_existing: :environment do
    ActiveRecord::Base.logger.silence do
      Agency.find_each do |agency|
        Metro::Importer.new(agency, logger: Logger.new(STDOUT)).import!
      end
    end
  end

  desc "Titleize existing metro data"
  task titleize: :environment do
    Stop.find_each do |s|
      s.update(
        name: Metro::StringHelper.titleize(s.name),
        description: Metro::StringHelper.titleize(s.description),
      )
    end
    Route.find_each do |r|
      r.update(
        long_name: Metro::StringHelper.titleize(r.long_name),
      )
    end
    Trip.find_each do |t|
      t.update(
        headsign: Metro::StringHelper.titleize_headsign(t.headsign),
      )
    end
  end
end
