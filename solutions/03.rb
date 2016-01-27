class Integer
  def prime?
    not (self == 1 || (2...self).any? { |x| self % x == 0 } )
  end
end

class PrimeSequence
  include Enumerable

  def initialize (limit)
  @limit = limit
  end

  def each
    count = 0
    number = 2
    while count < @limit
      if number.prime?
        yield number
        count += 1
      end
      number += 1
    end
  end
end

class RationalSequence
  include Enumerable

  def initialize (limit)
  @limit = limit
  end

  def to_a
    sequence, count, denom, num = [], 0, 1, 1
  while (@limit > count)
    sequence << Rational(num,denom)
    if(denom == 1 && num % 2 == 1)
      num += 1
      elsif(num == 1 && denom % 2 == 0)
      denom += 1
    elsif((num + denom) % 2 == 0)
      num += 1
    denom -= 1
    else
      num -= 1
    denom += 1
    end
    if(num.gcd(denom) == 1)
      count += 1
      end
  end
  sequence.uniq
  end

  def each
    counter = 0
    sequence = to_a
    while counter < @limit
      yield sequence[counter]
      counter += 1
    end
  end
end

class FibonacciSequence
  include Enumerable

 def initialize(limit, first: 1, second: 1)
    @limit = limit
    @first = first
    @second = second
  end

  def each
    count = 0
    while(count < @limit)
    yield @first
    @second, @first = @first + @second, @second
    count += 1
    end
  end
end

module DrunkenMathematician
  module_function

  def meaningless(limit)
    groups = RationalSequence.new(limit).partition do |rational|
      rational.numerator.prime? || rational.denominator.prime?
    end
    groups[0].reduce(1, :*) / groups[1].reduce(1, :*)
  end

  def aimless(limit)
    pairs = PrimeSequence.new(limit).each_slice(2).to_a
    pairs.last << 1 if limit.odd?
    sequence = pairs.map { |pair| Rational(pair[0], pair[1]) }
    sequence.reduce(:+)
  end

  def worthless(limit)
    max = FibonacciSequence.new(limit).to_a.last
    sequence = RationalSequence.new(max).to_a
    while (sequence.reduce(:+) > max)
      sequence.delete_at(-1)
    end
    sequence
  end
end
