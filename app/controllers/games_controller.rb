class GamesController < ApplicationController
  include Scoring

  def new
    dice = roll_dice
    @test_score = four_of_a_kind([1,1,2,2,2])
    @turn = Turn.create(dice_hash(dice))
    @game = Game.create

    @fields = %w(ones twos threes fours fives sixes
                 three_of_a_kind four_of_a_kind full_house
                 small_straight large_straight chance rahtzee)
  end

  def roll_again
    # turn.last is crude need to change to turn id
    @game = Game.find params[:game_id]
    @turn = Turn.find params[:turn_id]  
    roll_count = @turn.roll_counter
    if roll_count >= 3
      redirect_to(games_error_path)
      return
    end
    @turn.update :roll_counter => (roll_count + 1)

    # Roll Dice
    dice_to_roll = dice_check(params)
    dice_to_roll.each_with_index do |user_chose_to_roll_die, i|
      eval("@turn.update :dice_#{ i+1 } => rand(1..6)") if user_chose_to_roll_die
    end

    @fields = %w(ones twos threes fours fives sixes
                 three_of_a_kind four_of_a_kind full_house
                 small_straight large_straight chance rahtzee)

    render "new"
  end

  def enter_score
    @game = Game.find params[:game_id]
    @turn = Turn.find params[:turn_id] 
    dice = extract_dice(@turn)
    score_field = params['score_field']
    @score = eval("#{params['score_field']}(dice)")
    eval ("@game.update :#{score_field} => #{@score}")
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
    hash = {}
    (1..5).each do |i|
      hash["dice_#{i}".to_sym] = dice[i-1]
    end
    hash
  end

  def dice_check(params)
    dice_to_roll = []
    (1..5).each do |i|
      dice_to_roll[i - 1] = params.keys.include? "dice_#{i}"
    end
    dice_to_roll
  end

  def extract_dice(turn)
    dice = []
    (1..5).to_a.each { |i| dice << eval("turn.dice_#{i}") }
    dice
  end 
      
end