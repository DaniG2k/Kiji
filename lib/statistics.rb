module Enumerable  
  def mean
    reduce(:+).to_f / length
  end

  def sample_variance
    sum = inject(0){ |acc, i| acc + (i - mean)**2 }
    1 / length.to_f * sum
  end

  def standard_deviation
    Math.sqrt(sample_variance)
  end
  
  def zscore
    stdev = standard_deviation
    if stdev.zero?
      Array.new(length, 0)
    else
      collect { |v| (v - mean) / stdev } 
    end
  end
end