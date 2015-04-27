namespace :metro do
  task import: :environment do
    desc "Import metro data from go-metro.com"
    Metro::Importer.new(logger: Logger.new(STDOUT)).import!
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
