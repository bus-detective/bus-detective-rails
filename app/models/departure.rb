class Departure
  include ActiveModel::SerializerSupport
  attr_reader :stop_time

  def initialize(options)
    @date = options.fetch(:date)
    @stop_time = options.fetch(:stop_time)
    @stop_time_update = options.fetch(:stop_time_update)
  end

  delegate :route, :trip, to: :stop_time

  def realtime?
    @stop_time_update.present?
  end

  def time
    if @stop_time_update
      @stop_time_update.departure_time
    else
      # Need to apply the supplied date because ActiveRecord times will use 2000-01-01.
      # See: http://stackoverflow.com/questions/13257344
      time = @stop_time.departure_time.in_time_zone.strftime("%H:%M:%S %z")
      Time.zone.parse("#{@date} #{time}")
    end
  end

  def delay
    if @stop_time_update
      @stop_time_update.delay
    else
      0
    end
  end
end
