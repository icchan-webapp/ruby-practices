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
    FileMode.new(@name).connect_file_type_and_permission_symbols
  end

  def user
    Etc.getpwuid(@file_stat.uid)
  end

  def group
    Etc.getgrgid(@file_stat.gid)
  end

  def mtime
    @file_stat.mtime
  end
end
