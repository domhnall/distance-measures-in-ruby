class Metrics

  def self.euclidean_distance(a,b)
    return unless a.any? && (a.size == b.size)

    diff_squared = (0..a.size-1).reduce(0) do |sum, i|
      sum + (a[i] - b[i])**2
    end
    Math.sqrt(diff_squared)
  end

  def self.manhattan_distance(a, b)
    return unless a.any? && (a.size == b.size)

    (0..a.size-1).reduce(0) do |sum, i|
      sum + (a[i] - b[i]).abs
    end
  end

  def self.minkowski_distance(a, b, p)
    return unless a.any? && (a.size == b.size)

    (0..a.size-1).reduce(0) do |sum, i|
      sum + (a[i] - b[i]).abs**p
    end**(1.0/p)
  end

  def self.chebyshev_distance(a, b)
    return unless a.any? && (a.size == b.size)

    (0..a.size-1).map do |i|
      (a[i] - b[i]).abs
    end.max
  end

  def self.hamming_distance(a, b)
    return unless a.any? && (a.size == b.size)

    (0..a.size-1).reduce(0) do |sum, i|
      sum + ((a[i] != b[i]) ? 1 : 0)
    end
  end

  def self.cosine_similarity(a, b)
    return unless a.any? && (a.size == b.size)
    return if is_null?(a) || is_null?(b)

    dot_product(a,b) / (mod(a) * mod(b))
  end

  def self.jaccard_similarity(a, b)
    return unless a.any? && b.any?

    (a & b).size / (a | b).size.to_f
  end

  # Private class methods
  def self.dot_product(a, b)
    (0..a.size-1).reduce(0) do |sum, i|
      sum + a[i] * b[i]
    end
  end
  private_class_method :dot_product

  def self.mod(a)
    Math.sqrt((0..a.size-1).reduce(0) do |sum, i|
      sum + a[i]**2
    end)
  end
  private_class_method :mod

  def self.is_null?(a)
    a.all? {|i| i == 0 }
  end
  private_class_method :is_null?
end
