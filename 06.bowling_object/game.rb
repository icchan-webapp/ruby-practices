# frozen_string_literal: true

require 'debug'

class Game
  def initialize(frames)
    @frame_instances = frames.map { |frame| Frame.new(*frame) }
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
