class CreateStartTimeFunction < ActiveRecord::Migration
  def up
    execute "CREATE OR REPLACE FUNCTION start_time(start_date date DEFAULT current_date) RETURNS timestamp AS $$
DECLARE
  noon varchar(50);
BEGIN
  SELECT INTO noon to_char(start_date, 'YYYY-mm-dd') || ' 12:00:00';
  RETURN noon::timestamp - interval '12 hours';
END;
$$ LANGUAGE 'plpgsql'"
  end

  def down
    execute "DROP FUNCTION start_time(start_date date)"
  end
end
