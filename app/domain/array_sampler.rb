class ArraySampler < Struct.new(:array)

  # Sample the least used item in the array, given an array of used items.
  def least_used(other)
    unused = array - other

    return unused.sample if unused.any?

    usage_counts = Hash.new(0)

    other.each do |color|
      usage_counts[color] += 1
    end

    min_color = nil
    min_count = Float::INFINITY

    usage_counts.each do |color, count|
      if count < min_count
        min_color = color
        min_count = count
      end
    end

    min_color
  end

end