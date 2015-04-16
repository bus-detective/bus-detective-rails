namespace :metro do
  desc "Import metro data from go-metro.com"
  task import: :environment do
    Metro::Importer.new(logger: Logger.new(STDOUT)).import!
  end
end
