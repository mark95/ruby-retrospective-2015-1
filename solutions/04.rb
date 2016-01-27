class Card
  attr_accessor :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    @rank.to_s.capitalize + " of " + @suit.to_s.capitalize
  end

  def == (other)
    rank == other.rank and suit == other.suit
  end

  def > (other)
    ranks = [ :ace, :king, :queen, :jack, *(10.downto(2))].freeze
    suits = [:spades, :hearts, :diamonds, :clubs].freeze
    compare_rank = ranks.index(rank) <=> ranks.index(other.rank)
    compare_suit = suits.index(suit) <=> suits.index(other.suit)
    suit == other.suit ? compare_rank : compare_suit
  end

  def < (other)
    ranks = [:ace, 10, :king, :queen, :jack, 7, 8, 9].freeze
    suits = [:spades, :hearts, :diamonds, :clubs].freeze
    compare_rank = ranks.index(rank) <=> ranks.index(other.rank)
    compare_suit = suits.index(suit) <=> suits.index(other.suit)
    suit == other.suit ? compare_rank : compare_suit
  end
end

class Deck
  include Enumerable

  def ranks
    ranks = [ *(2..10), :jack, :queen, :king, :ace].freeze
  end

  def suits
    suits = [:clubs, :diamonds, :hearts, :spades].freeze
  end

  def basic_deck
    ranks.map { |x|  suits.map { |y| Card.new(x, y)  } }
  end

  def initialize(*deck)
    deck == [] ? @deck = basic_deck.flatten : @deck = deck.flatten
  end

  def each
    @deck.each { |card| yield card }
  end

  def size
    @deck.size
  end

  def draw_top_card
    @deck.shift
  end

  def draw_bottom_card
    @deck.pop
  end

  def top_card
    @deck.first
  end

  def bottom_card
    @deck.last
  end

  def shuffle
    @deck.shuffle!
  end

  def to_s
    @deck.map(&:to_s).join("\n")
  end
  def sort
    @deck.sort! { |a,b| a > b }
  end

 end

class WarDeck < Deck

  def deal
    WarHand.new(@deck.slice!(0,26))
  end
end

class WarHand
  def initialize(hand)
    @hand = hand
  end

  def size
    @hand.size
  end

  def play_card
    @hand.shift
  end

  def allow_face_up?
    size <= 3
  end

end

class BeloteDeck < Deck
  def basic_deck
    ranks = [ :ace, :king, :queen, :jack, 10, 9, 8, 7].freeze
    suits = [:spades, :hearts, :diamonds, :clubs].freeze
    suits.map { |x|  ranks.map { |y| Card.new(y, x)  } }
  end

  def deal
    BeloteHand.new(@deck.slice!(0,8))
  end

  def sort
    @deck.sort! { |a,b| a < b }
  end
end

class BeloteHand
  def initialize(hand)
    @basic_hand = hand
    @hand = { :spades => [], :hearts => [], :diamonds => [], :clubs => [] }
    hand.map { |elem| @hand[elem.suit] << elem.rank }
  end

  def size
    @basic_hand.size
  end

  def highest_of_suit(suit)
    BeloteDeck.new(@basic_hand.select { |card| card.suit == suit }).sort.first
  end

  def belote?
    suits = [:spades, :hearts, :diamonds, :clubs].freeze
    ranks = [:king, :queen].freeze
    suits_array = (0...4).map { |index| (ranks & @hand[suits[index]]) == ranks}
    suits_array.any? { |elements| elements == true }
  end

  def find_consecutive?(count)
    suits = [:spades, :hearts, :diamonds, :clubs].freeze
    ranks = [ :ace, 10, :king, :queen, :jack, 9, 8, 7].freeze
    ranks.each_cons(count).any? do |cons|
      (cons & @hand[:spades]) == cons || (cons & @hand[:hearts]) == cons ||
        (cons & @hand[:diamonds]) == cons || (cons & @hand[:clubs]) == cons
    end
  end

  def tierce?
    find_consecutive?(3)
  end

  def quarte?
    find_consecutive?(4)
  end

  def quint?
    find_consecutive?(5)
  end

  def find_carre?(rank)
    @basic_hand.count { |card| card.rank == rank } == 4
  end

  def carre_of_jacks?
    find_carre?(:jack)
  end

  def carre_of_nines?
    find_carre?(9)
  end

  def carre_of_aces?
    find_carre?(:ace)
  end
end

class SixtySixDeck < Deck
  def basic_deck
    ranks = [ :ace, :king, :queen, :jack, 10, 9].freeze
    suits = [:spades, :hearts, :diamonds, :clubs].freeze
    suits.map { |x|  ranks.map { |y| Card.new(y, x) } }
  end

  def deal
    SixtySixHand.new(@deck.slice!(0,6))
  end

  def sort
    @deck.sort! { |a,b| a < b }
  end
end

class SixtySixHand

  def initialize(hand)
    @hand = hand
  end

  def size
    @hand.size
  end

  def twenty?(trump_suit)
    suits = [:spades, :hearts, :diamonds, :clubs]
    suits.select { |suit| suit != trump_suit }.any? { |suit| forty?(suit) }
  end

  def forty?(trump_suit)
    @hand.select { |card| card.suit == trump_suit }.
    select { |card| card.rank == :king || card.rank == :queen }.size == 2
  end
end
