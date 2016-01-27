class Card

  def initialize(rank, suit)
    @rank = rank
        @suit = suit
  end

  def rank
    @rank
  end

  def suit
    @suit
  end

  def to_s
    ranks = { :jack => "Jack", :queen => "Queen",
                  :king => "King", :ace => "Ace" }
    ranks.fetch(@rank, @rank)
        suits = { :spades => "Spades", :clubs => "Clubs",
                  :diamonds => "Diamonds", :hearts => "Hearts" }
    suits.fetch(@suit, @suit)
    "#{ ranks.fetch(@rank, @rank) } of #{ suits.fetch(@suit, @suit) }"
  end

  def == (other)
    rank == other.rank and suit == other.suit
  end

  def > (other)
    ranks = [ :ace, :king, :queen, :jack, 10, 9, 8, 7, 6, 5, 4, 3, 2 ]
    suits = [:spades, :hearts, :diamonds, :clubs ]
        compare_rank = ranks.index(rank) <=> ranks.index(other.rank)
        compare_suit = suits.index(suit) <=> suits.index(other.suit)
    suit == other.suit ? compare_rank : compare_suit
  end

  def < (other)
    ranks = [:ace, 10, :king, :queen, :jack, 7, 8, 9 ]
    suits = [:spades, :hearts, :diamonds, :clubs ]
    compare_rank = ranks.index(rank) <=> ranks.index(other.rank)
        compare_suit = suits.index(suit) <=> suits.index(other.suit)
    suit == other.suit ? compare_rank : compare_suit
  end
end

class Deck
  include Enumerable
  def ranks
    ranks = [ 2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]
  end

  def suits
    suits = [:clubs, :diamonds, :hearts, :spades]
  end

  def basic_deck
    ranks.map { |x|  suits.map { |y| Card.new(x, y)  } }
  end

  def initialize(*deck )
    deck == [] ? @deck = basic_deck.flatten : @deck = deck.flatten
  end

  def each(&block)
        @deck.each(&block)
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
    puts @deck
  end
  def sort
    @deck.sort! { |a,b| a > b }
  end

  def deal
  end
 end

class WarDeck < Deck

  def deal
    count = 0
    hand = []
    while(count < 26)
          hand << draw_top_card
          count += 1
        end
        WarHand.new(hand)
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
  ranks = [ :ace, :king, :queen, :jack, 10, 9, 8, 7 ]
  suits = [:spades, :hearts, :diamonds, :clubs ]
  suits.map { |x|  ranks.map { |y| Card.new(y, x)  } }
  end

  def deal
    count = 0
    hand = []
    while(count < 8)
          hand << draw_top_card
          count += 1
        end
        BeloteHand.new(hand)
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
        ranks,count = [7, 8, 9, :jack, :queen, :king, 10, :ace ], 0
        while(count < 8)
           if (@basic_hand.include?(Card.new(ranks[count],suit)))
                max = Card.new(ranks[count],suit)
          end
          count += 1
        end
          max
  end

  def belote?
        suits = [:spades, :hearts, :diamonds, :clubs]
        ranks = [:king, :queen]
        suits_array = (0...4).map { |index| (ranks & @hand[suits[index]]) == ranks }
        suits_array.any? { |elements| elements == true }
  end

  def find_consecutive?(count)
        suits,flag = [:spades, :hearts, :diamonds, :clubs], false
        ranks = [ :ace, 10, :king, :queen, :jack, 9, 8, 7 ]
        ranks.each_cons(count) do |cons|
                if ((cons & @hand[:spades]) == cons || (cons & @hand[:hearts]) == cons)
          flag = true
        end
                if((cons & @hand[:diamonds]) == cons || (cons & @hand[:clubs]) == cons)
          flag = true
                end
        end
        flag
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
    include_spade = @hand[:spades].include?(rank)
        include_heart = @hand[:hearts].include?(rank)
        include_diamond = @hand[:diamonds].include?(rank)
        include_club = @hand[:clubs].include?(rank)
    include_club and include_diamond and include_heart and include_spade
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
  ranks = [ :ace, :king, :queen, :jack, 10, 9]
  suits = [:spades, :hearts, :diamonds, :clubs ]
  suits.map { |x|  ranks.map { |y| Card.new(y, x)  } }
  end

  def deal
    count = 0
    hand = []
    while(count < 6)
          hand << draw_top_card
          count += 1
        end
        SixtySixHand.new(hand)
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
        suits.delete(trump_suit)
        twenties = (0...3).map { |index|
          include_queen = @hand.include?(Card.new(:queen, suits[index]))
          include_king = @hand.include?(Card.new(:king, suits[index]))
          include_queen and include_king
        }
        twenties.any? { |element| element == true }
  end

  def forty?(trump_suit)
    include_queen = @hand.include?(Card.new(:queen, trump_suit))
        include_king = @hand.include?(Card.new(:king, trump_suit))
        include_queen and include_king
  end
end
