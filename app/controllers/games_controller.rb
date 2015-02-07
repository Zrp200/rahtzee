class GamesController < ApplicationController
  include Scoring

  def new
    dice = roll_dice
    @test_score = four_of_a_kind([1,1,2,2,2])
    @turn = Turn.create(dice_hash(dice))

    @fields = %w(ones twos threes fours fives sixes
                 three_of_a_kind four_of_a_kind full_house
                 small_straight large_straight chance rahtzee)
  end

  def roll_again
    # turn.last is crude need to change to turn id
    @turn = Turn.last    
    roll_count = @turn.roll_counter
    if roll_count >= 3
      redirect_to(games_error_path)
      return
    end
    @turn.update roll_counter: (roll_count + 1)

    # Roll Dice
    dice_check(params).each_with_index do |user_chose_to_roll_die, i|
      eval("@turn.update :dice_#{ i+1 } => rand(1..6)") if user_chose_to_roll_die
    end

    @fields = %w(ones twos threes fours fives sixes
                 three_of_a_kind four_of_a_kind full_house
                 small_straight large_straight chance rahtzee)

    render "new"
  end

  def enter_score
    @turn = Turn.last
    dice = extract_dice(@turn)
    @score = eval("#{params['score_field']}(dice)")
    @dice = dice.to_s
  end

  def error
  end

  private
  def roll_dice(dice = [true]*5)
    dice.map! {|d| rand(1..6) if d}
    dice
  end

  def dice_hash(dice)
    hash = Hash.new
    (1..5).each {|i| hash["dice_#{i}".to_sym] = dice[i-1]}
    hash
  end

  def dice_check(params)
    dice_to_roll = Array.new
    (1..5).each { |i| dice_to_roll[i - 1] = params.keys.include? "dice_#{i}" }
    dice_to_roll
  end

  def extract_dice(turn)
    dice = Array.new
    (1..5).to_a.each { |i| dice << eval("turn.dice_#{i}") }
    dice
  end 
      
end
