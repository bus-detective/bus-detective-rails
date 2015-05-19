class CreateServiceDaysView < ActiveRecord::Migration
  def up
    execute "
CREATE OR REPLACE VIEW service_days AS
SELECT sd.id, sd.agency_id, sd.remote_id, sd.start_date, sd.end_date, sd.dow
FROM (
SELECT id, agency_id, remote_id, start_date, end_date,
	UNNEST(ARRAY['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday']) as dow,
	UNNEST(ARRAY[monday, tuesday, wednesday, thursday, friday, saturday, sunday]) as active
FROM services) sd
WHERE sd.active;
"
  end

  def down
    execute "DROP VIEW service_days"
  end
end

