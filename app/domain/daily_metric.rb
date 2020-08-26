class DailyMetric

  attr_reader :day_values

  def self.delta(day, value)
    new({day => value})
  end

  def self.zero
    new({})
  end

  def initialize(raw_day_values)
    @day_values = normalize_dates(raw_day_values)
  end

  def on(date)
    day_values[date.to_date].to_f
  end

  def over(date_range)
    date_range.map { |date| on(date) }
  end

  def cumulative_over(date_range)
    sum = 0.0

    over(date_range).map do |value|
      sum += value
      sum
    end
  end

  def *(scalar)
    scaled_day_values = day_values.inject({}) do |h, (day, value)|
      h[day] = value * scalar
      h
    end

    DailyMetric.new(scaled_day_values)
  end

  def +(other)
    summed_day_values = Hash.new(0)

    day_values.each do |day, value|
      summed_day_values[day] = value
    end

    other.day_values.each do |day, value|
      summed_day_values[day] += value
    end

    DailyMetric.new(summed_day_values)
  end

  def -(other)
    self + (other * -1)
  end

  private

    def normalize_dates(raw_day_values)
      raw_day_values.inject({}) do |h, (day, value)|
        h[day.to_date] = value
        h
      end
    end

end