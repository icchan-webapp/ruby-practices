# frozen_string_literal: true

require 'debug'

class Game
  def initialize
    @frames = scores_per_frame.map { |score_per_frame| Frame.new(*score_per_frame) }
  end

  def scores_per_frame
    scores = ARGV[0].split(',')

    scores_per_frame = []
    score_per_frame = []

    scores.each do |score|
      score_per_frame << score

      if scores_per_frame.size < 10
        if score_per_frame.size >= 2 || score == 'X'
          scores_per_frame << score_per_frame.dup
          score_per_frame.clear
        end
      else
        scores_per_frame.last << score
      end
    end

    scores_per_frame
  end

  def score
    score = 0

    @frames.each.with_index(1) do |frame, i|
      next_frame, after_next_frame = @frames.slice(i, 2)
      score += frame.score

      next if i == 10 || !frame.strike_or_spare?

      score += next_frame.first_shot.score

      next if frame.spare?

      score += next_frame.second_shot.score

      next if i == 9

      score += after_next_frame.first_shot.score if next_frame.strike?
    end

    score
  end
end
