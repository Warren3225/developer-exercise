class Card
  attr_accessor :suite, :name, :value #specifiy that class attributes are both, readable and writable
  #constructor
  def initialize(suite, name, value) 
    @suite, @name, @value = suite, name, value
  end
end

class Deck
  attr_accessor :playable_cards
  SUITES = [:hearts, :diamonds, :spades, :clubs] #constant 
  NAME_VALUES = { 
    :two   => 2,
    :three => 3,
    :four  => 4,
    :five  => 5,
    :six   => 6,
    :seven => 7,
    :eight => 8,
    :nine  => 9,
    :ten   => 10,
    :jack  => 10,
    :queen => 10,
    :king  => 10,
    :ace   => 11}

  def initialize #initialzing shuffles the deck
    shuffle 
  end

  def deal_card #removes card from deck
    random = rand(@playable_cards.size) #returns an random int greater >= 0 & < max
    @playable_cards.delete_at(random)
  end

  def shuffle
    @playable_cards = [] #array of 52 cards
    SUITES.each do |suite| #iterate over suites
      NAME_VALUES.each do |name, value| #iterate, over card for that suite
        @playable_cards << Card.new(suite, name, value) #add to end of array, new Card
      end
    end
  end
end

class Hand
  attr_accessor :cards
  def initialize
    @cards = []
  end

  # reduce(0) {|sum, card| sum + card.value }

  def recieve_card(card)
    @cards.push(card)
    #value = @cards.reduce(0) {|sum, card| sum + card.value }
  end
end

class Player
  attr_accessor :player_hand, :player_points
  

  def initialize
    @player_hand = Hand.new
  end

  def hit_me(dealer)
    @player_hand.cards.push(dealer.dealer_deck.deal_card)
    @player_points = @player_hand.cards.reduce(0) {|sum, card| sum + card.value} 
      if @player_points > 21
        puts @player_points, "BUSTED - PLAYER LOSES"
      elsif @player_points == 21
        puts @player_points, "BLACKJACK! - PLAYER WINS"
      end
  end
end

class Dealer 
  attr_accessor :dealer_hand, :dealer_deck, :dealer_points

  def initialize
    @dealer_hand = Hand.new
    @dealer_deck = Deck.new
  end

  def deal_to_player(player) 
    card = @dealer_deck.deal_card
    player.player_hand.recieve_card(card)

    card = @dealer_deck.deal_card
    player.player_hand.recieve_card(card)
  end

  def deal_to_self
    card = @dealer_deck.deal_card
    @dealer_hand.cards.push(card)
  end

  def deals_to_self_until_end(player)
    player_points = player.player_points
    @dealer_points = @dealer_hand.cards.reduce(0) {|sum, card| sum + card.value} 
    puts @dealer_points
    while @dealer_points < 17 do
      deal_to_self()
      @dealer_points = @dealer_hand.cards.reduce(0) {|sum, card| sum + card.value} 
      if @dealer_points > 21 
        puts @dealer_points, "Dealer Loses - Player Wins"
      elsif @dealer_points > player_points
        puts @dealer_points, "Dealer Wins"
      end
    end
  end
end

=begin
warren = Player.new
devin = Dealer.new

devin.deal_to_player(warren)
devin.deal_to_self()
warren.hit_me(devin)
puts warren.player_hand.cards[0].value
puts warren.player_hand.cards[1].value
puts warren.player_hand.cards[2].value
devin.deals_to_self_until_end(warren)
=end

require 'test/unit'

class CardTest < Test::Unit::TestCase
  def setup
    @card = Card.new(:hearts, :ten, 10)
  end
  
  def test_card_suite_is_correct
    assert_equal @card.suite, :hearts
  end

  def test_card_name_is_correct
    assert_equal @card.name, :ten
  end
  def test_card_value_is_correct
    assert_equal @card.value, 10
  end
end

class DeckTest < Test::Unit::TestCase
  def setup
    @deck = Deck.new
  end
  
  def test_new_deck_has_52_playable_cards
    assert_equal 52, @deck.playable_cards.size
  end
  
  def test_dealt_card_should_not_be_included_in_playable_cards
    card = @deck.deal_card
    refute @deck.playable_cards.include?(card) #upon dealing card, card should be removed from deck
  end

  def test_shuffled_deck_has_52_playable_cards
    @deck.shuffle
    assert_equal @deck.playable_cards.size, 52
  end
end