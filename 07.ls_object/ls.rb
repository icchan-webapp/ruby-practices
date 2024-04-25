#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative './file_display'
require_relative './file_detail'
require_relative './file_mode'

FileDisplay.new.format_file_detail_strings
