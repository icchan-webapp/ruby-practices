# frozen_string_literal: true

require 'optparse'

def exec
  opt = OptionParser.new
  params = { number_of_lines: false, number_of_words: false, bytesize: false }
  opt.on('-l') { |v| params[:number_of_lines] = v }
  opt.on('-w') { |v| params[:number_of_words] = v }
  opt.on('-c') { |v| params[:bytesize] = v }
  opt.parse!(ARGV)
  params.transform_values!(&:!) unless params.values.any?

  ARGV.empty? ? wc_stdin(params) : wc_files(params)
end

def wc_stdin(params)
  lines = ARGF.to_a
  stat = build_stat(lines)
  print_format(params, stat)
end

def wc_files(params, paths: ARGV)
  path_stats =
    paths.map do |path|
      lines = File.read(path).lines
      build_stat(lines, path:)
    end

  path_stats << build_total(path_stats) if path_stats.size > 1
  path_stats.each { |stat| print_format(params, stat) }
end

def build_stat(lines, path: nil)
  number_of_lines = lines.size
  words = lines.join.split(/\s+/)
  number_of_words = words.size
  bytesize = lines.map(&:bytesize).sum

  { number_of_lines:, number_of_words:, bytesize:, path: }
end

def build_total(path_stats)
  total_lines = path_stats.map { |stat| stat[:number_of_lines] }.sum
  total_words = path_stats.map { |stat| stat[:number_of_words] }.sum
  total_bytesize = path_stats.map { |stat| stat[:bytesize] }.sum

  {
    number_of_lines: total_lines,
    number_of_words: total_words,
    bytesize: total_bytesize,
    path: 'total'
  }
end

WIDTH = 8

def print_format(params, stat)
  print stat.map { |wc_opt, value_for_wc_opt| value_for_wc_opt.to_s.rjust(WIDTH) if params[wc_opt] }.join
  puts " #{stat[:path]}"
end

exec
