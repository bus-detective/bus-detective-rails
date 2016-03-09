class FixEffectiveServices < ActiveRecord::Migration
  def up
    execute <<-SQL
    CREATE OR REPLACE FUNCTION effective_services(start_date date DEFAULT current_date, end_date DATE DEFAULT (current_date + interval '1 day'))
RETURNS table (agency_id int, service_id int, date date, dow char(1)) AS $$
  SELECT agencies.id as agency_id, service_exceptions.service_id, d as date, rtrim(to_char(days.d, 'day')) as dow
     FROM agencies
       CROSS JOIN (SELECT d::date FROM generate_series(start_date, end_date, interval '1 day') d) days
       INNER JOIN service_days ON service_days.dow = rtrim(to_char(days.d, 'day')) AND agencies.id = service_days.agency_id and days.d between service_days.start_date and service_days.end_date
       INNER JOIN service_exceptions ON service_exceptions.date = days.d AND agencies.id = service_exceptions.agency_id
       WHERE service_exceptions.exception = 1
     UNION ALL
     SELECT agencies.id as agency_id, service_days.id, d as date, rtrim(to_char(days.d, 'day')) as dow
     FROM agencies
       CROSS JOIN (SELECT d::date FROM generate_series(start_date, end_date, interval '1 day') d) days
       INNER JOIN service_days ON service_days.dow = rtrim(to_char(days.d, 'day')) AND agencies.id = service_days.agency_id and days.d between service_days.start_date and service_days.end_date
       LEFT JOIN service_exceptions ON service_exceptions.date = days.d AND agencies.id = service_exceptions.agency_id AND service_days.id = service_exceptions.service_id
       WHERE service_exceptions IS NULL OR service_exceptions.exception != 2
$$ LANGUAGE SQL;
SQL
  end

  def down
    execute "DROP FUNCTION effective_services(start_date date, end_date date)"
  end
end

