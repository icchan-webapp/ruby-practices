# frozen_string_literal: true

require 'etc'
require 'forwardable'

class FileDetail
  extend Forwardable

  attr_reader :name

  delegate %i[blocks nlink size mtime] => :@file_stat
  delegate %i[entry_type permissions] => :@file_mode

  def initialize(file_name)
    @file_stat = File.stat(file_name)
    @name = file_name
    @file_mode = FileMode.new(@name)
  end

  def user
    Etc.getpwuid(@file_stat.uid)
  end

  def user_name
    user.name
  end

  def group
    Etc.getgrgid(@file_stat.gid)
  end

  def group_name
    group.name
  end
end
