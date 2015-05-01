namespace :metro do
  task :import, [:gtfs_endpoint] => [:environment] do |t, args|
    desc "Import metro data from go-metro.com"
    ActiveRecord::Base.logger.silence do
      logger = Logger.new(STDOUT)

      if args[:gtfs_endpoint]
        agency = Agency.find_or_create_by(gtfs_endpoint: args[:gtfs_endpoint])
        Metro::Importer.new(agency, logger: logger).import!
      else
        Agency.find_each do |agency|
          Metro::Importer.new(agency, logger: logger).import!
        end
      end
    end
  end

  task titleize: :environment do
    desc "Titleize existing metro data"
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
