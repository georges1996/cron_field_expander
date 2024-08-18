# frozen_string_literal: true

require_relative 'cron_field_expander'

MINUTE_RANGE = (0..59).freeze
HOUR_RANGE = (0..23).freeze
DAY_OF_MONTH_RANGE = (1..31).freeze
MONTH_RANGE = (1..12).freeze
DAY_OF_WEEK_RANGE = (0..6).freeze

class CronParser
  def initialize(cron_string)
    @cron_string = cron_string.strip
  end

  def parse
    validate_format
    fields = @cron_string.split(' ', 6)
    minute, hour, day_of_month, month, day_of_week, command = fields

    cron_map = {
      'minute' => [minute, MINUTE_RANGE],
      'hour' => [hour, HOUR_RANGE],
      'day of month' => [day_of_month, DAY_OF_MONTH_RANGE],
      'month' => [month, MONTH_RANGE],
      'day of week' => [day_of_week, DAY_OF_WEEK_RANGE]
    }

    expanded_fields = cron_map.map do |field_name, (field, range)|
      expander = CronFieldExpander.new(range, field_name)
      expanded_values = expander.expand(field)
      [field_name, expanded_values]
    end

    expanded_fields.each do |field_name, values|
      puts "#{field_name.ljust(14)} #{values.join(' ')}"
    end

    puts "command       #{command}"
  end

  private

  def validate_format
    fields = @cron_string.split(' ', 6)
    return if fields.length == 6

    raise 'Invalid cron format. Please provide exactly 5 time fields and 1 command.'
  end
end
