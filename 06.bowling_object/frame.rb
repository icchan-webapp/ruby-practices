# frozen_string_literal: true

class Frame
  attr_reader :first_shot, :second_shot

  def initialize(first_mark, second_mark = nil, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark) if third_mark
    @score = [first_shot.score, second_shot.score].sum
  end

  def score
    @score += @third_shot.score if @third_shot
    @score
  end

  def spare?
    !strike? && @score == 10
  end

  def strike?
    first_shot.score == 10
  end

  def strike_or_spare?
    strike? || spare?
  end
end
