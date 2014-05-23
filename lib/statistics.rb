class Array
  def mean(len=self.length)
    reduce(:+).to_f / len
  end

  def sample_variance
    len = length
    m = mean(len)
    sum = reduce { |acc, i| acc + (i - m)**2 }
    sum.to_f / len
  end

  def standard_deviation
    Math.sqrt(sample_variance)
  end
  
  def zscore
    stdev = standard_deviation
    m = mean
    stdev.zero? ? Array.new(length, 0) : collect { |v| (v - m) / stdev }
  end
end