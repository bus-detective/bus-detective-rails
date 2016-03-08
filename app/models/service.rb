class Service < ActiveRecord::Base
  belongs_to :agency
  has_many :trips, dependent: :destroy
  has_many :stop_times, through: :trips

  def self.for_time(time)
    # This looks weird, but the days are boolean columns and
    # 'select * from foo where bar' works in postgres for boolean columns
    where(time.strftime('%A').downcase)
      .where('? between services.start_date and services.end_date', time)
  end
end
