module Enumerable
  def sum
    reduce(:+)
  end
  
  def mean
    sum / length.to_f
  end

  def sample_variance 
    avg = mean
    sum = inject(0){ |acc, i| acc + (i-avg)**2 }
    1/length.to_f*sum
  end

  def standard_deviation
    Math.sqrt(sample_variance)
  end
  
  def zscore
    collect { |v| (v - mean) / standard_deviation }
  end
end