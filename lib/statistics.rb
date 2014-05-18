class Array
  def mean
    reduce(:+).to_f / length
  end

  def sample_variance
    m = mean
    sum = reduce { |acc, i| acc + (i - m)**2 }
    1 / length.to_f * sum
  end

  def standard_deviation
    Math.sqrt(sample_variance)
  end
  
  def zscore
    stdev = standard_deviation
    m = mean
    if stdev.zero?
      Array.new(length, 0)
    else
      collect { |v| (v - m) / stdev } 
    end
  end
end