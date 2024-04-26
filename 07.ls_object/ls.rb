#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative './file_display'
require_relative './file_detail'
require_relative './file_mode'

FileDisplay.new.show_formatted_file_details
