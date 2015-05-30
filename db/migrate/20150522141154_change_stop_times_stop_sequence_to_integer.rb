class ChangeStopTimesStopSequenceToInteger < ActiveRecord::Migration
  def up
    rename_column :stop_times, :stop_sequence, :stop_sequence_txt
    add_column :stop_times, :stop_sequence, :integer

    execute "UPDATE stop_times SET stop_sequence=cast(stop_sequence_txt as int)"

    remove_column :stop_times, :stop_sequence_txt
  end

  def down
    rename_column :stop_times, :stop_sequence, :stop_sequence_int
    add_column :stop_times, :stop_sequence, :string

    execute "UPDATE stop_times SET stop_sequence=cast(stop_sequence_int as text)"

    remove_column :stop_times, :stop_sequence_int
  end
end
