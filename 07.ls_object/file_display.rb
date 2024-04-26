# frozen_string_literal: true

require 'optparse'

class FileDisplay
  COLUMN_COUNT = 3

  def initialize
    @options = ARGV.getopts('alr').transform_keys(&:to_sym)
    @file_details = fetch_file_details
  end

  def show_formatted_file_details
    @options[:l] ? long_format : short_format
  end

  private

  def fetch_file_details
    flags = @options[:a] ? File::FNM_DOTMATCH : 0
    file_names = Dir.glob('*', flags)
    sorted_file_names = @options[:r] ? file_names.reverse : file_names
    sorted_file_names.map { |file_name| FileDetail.new(file_name) }
  end

  def long_format
    blocks_total = @file_details.map(&:blocks).sum
    puts "total #{blocks_total}"

    @file_details.each { |file_detail| puts format_file_detail(file_detail) }
  end

  def format_file_detail(file_detail)
    max_size_map = build_max_size_map(@file_details)
    stat_map = {
      file_mode: file_detail.file_mode,
      nlink: file_detail.nlink,
      user_name: file_detail.user_name,
      group_name: file_detail.group_name,
      size: file_detail.size,
      mtime: file_detail.mtime.strftime('%_m %_d %H:%M'),
      name: file_detail.name
    }
    merged_file_detail = [
      '%<file_mode>s',
      "%<nlink>#{max_size_map[:nlink] + 1}s",
      "%<user_name>-#{max_size_map[:user_name] + 1}s",
      "%<group_name>-#{max_size_map[:group_name] + 1}s",
      "%<size>#{max_size_map[:size]}s",
      '%<mtime>2s',
      "%<name>s\n"
    ].join(' ')

    format(merged_file_detail, stat_map)
  end

  def build_max_size_map(file_details)
    {
      nlink: file_details.map { |file_detail| file_detail.nlink.to_s.size }.max,
      user_name: file_details.map { |file_detail| file_detail.user.name.size }.max,
      group_name: file_details.map { |file_detail| file_detail.group.name.size }.max,
      size: file_details.map { |file_detail| file_detail.size.to_s.size }.max,
      name: file_details.map { |file_detail| file_detail.name.to_s.size }.max
    }
  end

  def short_format
    file_names = @file_details.map(&:name)
    width = file_names.map(&:size).max + 1
    row_count = (file_names.size.to_f / COLUMN_COUNT).ceil
    format_file_names(file_names, width, row_count)
  end

  def format_file_names(file_names, width, row_count)
    (0..row_count - 1).each do |i|
      files_for_row = []
      file_name_index = i

      while file_name_index <= file_names.size - 1
        files_for_row << file_names[file_name_index].ljust(width)
        file_name_index += row_count
      end

      puts files_for_row.join
    end
  end
end
