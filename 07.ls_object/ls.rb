#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative './file_display'
require_relative './file_stat'
require_relative './file_mode'

FileDisplay.new.select_format
