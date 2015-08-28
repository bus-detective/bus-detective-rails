task :load_test, [:host] => [:environment]  do |t, args|
  desc "Load test an environment `rake load_test[app.busdetective.com]`"
  host = args[:host] || "127.0.0.1:3000"
  puts "Load Testing: #{host}"

  Stop.limit(10).each do |stop|
    `ab -n 25 -c 10 'http://#{host}/api/stops?query=#{stop.name.split(" ").first}&page=#{rand(1..5)}'`
    `ab -n 25 -c 10 'http://#{host}/api/stops?latitude=#{rand(39.235..39.236)}&longitude=-#{rand(84.546..84.547)}&page=#{rand(1..5)}'`
    `ab -n 50 -c 10 'http://#{host}/api/departures?stop_id=#{stop.id}'`
    `ab -n 50 -c 10 'http://#{host}/api/stops/#{stop.id}'`
  end
end
