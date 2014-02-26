module Enumerable
  def sum
    reduce(:+)
  end
  
  def mean
    sum.to_f / length
  end

  def sample_variance
    sum = inject(0){ |acc, i| acc + (i - mean)**2 }
    1 / length.to_f * sum
  end

  def standard_deviation
    Math.sqrt(sample_variance)
  end
  
  def zscore
    collect { |v| (v - mean) / (standard_deviation.nonzero? || 1) }
  end
end