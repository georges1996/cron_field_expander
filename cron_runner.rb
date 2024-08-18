#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/cron_parser'

if ARGV.length != 1
  puts "Usage: #{$PROGRAM_NAME} '<cron_string>'"
  exit 1
end

cron_input = ARGV[0]
parser = CronParser.new(cron_input)
parser.parse
