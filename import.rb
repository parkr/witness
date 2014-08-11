#!/usr/bin/env ruby

require 'csv'
require 'dotenv'
require 'sequel'
require 'active_record'
require_relative 'lib/witness'

Dotenv.load!

ActiveRecord::Base.establish_connection(
  :adapter  => "mysql2",
  :username => ENV['GOSSIP_DB_USERNAME'],
  :password => ENV['GOSSIP_DB_PASSWORD'],
  :database => ENV['GOSSIP_DB_DBNAME'],
)

file = ARGV[0] || -> { raise ArgumentError.new("Pass a CSV filename to import.") }.call

CSV.foreach(ARGV.fetch(0)) do |row|
  m = Message.new
  m.room    = '#jekyll'
  m.author  = row[1]
  m.message = row[2]
  m.at      = Time.parse(row[0])
  unless (already = Message.where("at = ? AND message = ?", m.at, m.message)).empty?
    puts "ALREADY THERE"
    p already
  else
    m.save!
  end
  puts "=" * 79
end
