class DateRange

  include Enumerable

  attr_reader :first_date, :last_date

  def initialize(first_date, last_date)
    @first_date = first_date.to_date
    @last_date = last_date.to_date
  end

  def each
    (first_date..last_date).each do |date|
      yield date
    end
  end

  def to_range
    first_date...last_date
  end

end