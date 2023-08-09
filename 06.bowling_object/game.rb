# frozen_string_literal: true

require 'debug'

class Game
  def initialize
    @frame_instances = scores_per_frame.map { |score_per_frame| Frame.new(*score_per_frame) }
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

    @frame_instances.each.with_index(1) do |frame_instance, i|
      next_frame_instance, after_next_frame_instance = @frame_instances.slice(i, 2)
      score += frame_instance.score

      next if i == 10 || !frame_instance.strike_or_spare?

      score += next_frame_instance.first_shot.score

      next if frame_instance.spare?

      score += next_frame_instance.second_shot.score

      next if i == 9

      score += after_next_frame_instance.first_shot.score if next_frame_instance.strike?
    end

    score
  end
end
