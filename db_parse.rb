# encoding: utf-8
require "rubygems"
require 'bundler/setup'
require "active_record"
require "active_support"


class DbParse
  RawObject.limit(10).each do | obj |
    puts 1
  end
end