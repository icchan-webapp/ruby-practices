# frozen_string_literal: true

require 'etc'
require 'forwardable'

class FileStat
  extend Forwardable

  attr_reader :name

  delegate %i[blocks nlink size] => :@file_stat

  def initialize(file_name)
    @file_stat = File.stat(file_name)
    @name = file_name
  end

  def file_mode
    FileMode.new(@name).build
  end

  def user_name
    Etc.getpwuid(@file_stat.uid).name
  end

  def group_name
    Etc.getgrgid(@file_stat.gid).name
  end

  def mtime
    @file_stat.mtime.strftime('%_m %_d %H:%M')
  end

  def build
    { file_mode:, nlink:, user_name:, group_name:, size:, mtime:, name: }
  end
end
