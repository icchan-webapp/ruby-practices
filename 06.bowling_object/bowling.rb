#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative './shot'
require_relative './frame'
require_relative './game'

scores = ARGV[0].split(',')

frames = []
frame = []

scores.each do |score|
  frame << score

  if frames.size < 10
    if frame.size >= 2 || score == 'X'
      frames << frame.dup
      frame.clear
    end
  else
    frames.last << score
  end
end

game = Game.new(frames)
puts game.score
