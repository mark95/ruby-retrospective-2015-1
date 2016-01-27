def prime?(n)
  not (n == 1 || (2...n).any? { |x| n % x == 0 } )
end


class PrimeSequence

  def initialize (limit)
  @limit = limit
  end

  def to_a
    (2..Float::INFINITY).
    lazy.
    select { |x| prime?(x) }.
    first(@limit)
  end
end



class RationalSequence

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
end

class FibonacciSequence

  def initialize (limit, first = { first: 1 }, second = { second: 1 } )
   @limit, @first, @second = limit, first[:first], second[:second]
  end

  def to_a
    count = 1
        sequence = [@first]
        while(count < @limit)
          sequence << @second
          @second, @first = @first + @second, @second
          count += 1
        end
        sequence
  end
end

module DrunkenMathematician
  module_function

  def meaningless(limit)
    sequence = RationalSequence.new(limit).to_a
        prime_sequence = sequence.select { |x| prime?(x.denominator) || prime?(x.numerator) }
        prime_sequence << 1
        compose_sequence = sequence - prime_sequence
        prime_sequence.reduce(:*) / compose_sequence.reduce(:*)
  end

  def aimless(limit)
    sequence = PrimeSequence.new(limit).to_a
        count, new_sequence = 0, []
        while (count < limit)
          new_sequence << Rational(sequence.fetch(count), sequence.fetch(count + 1, 1))
          count += 2
        end
        new_sequence.reduce(:+)
  end

  def worthless(limit)
    max = FibonacciSequence.new(limit).to_a.last
        puts max
        sequence = RationalSequence.new(limit + 1).to_a
        while (sequence.reduce(:+) > max)
          sequence.delete_at(-1)
        end
    sequence
  end
end
