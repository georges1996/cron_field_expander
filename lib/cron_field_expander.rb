# frozen_string_literal: true

require 'set'

class CronFieldExpander
  def initialize(range, field_name)
    @range = range
    @field_name = field_name
  end

  def expand(field, step = 1)
    if wildcard?(field)
      expand_wildcard(step)
    elsif list?(field)
      expand_list(field, step)
    elsif range?(field)
      expand_range(field, step)
    elsif step?(field)
      expand_step(field)
    else
      value = convert_to_number(field)
      validate_value_in_range(value)
      [value]
    end
  end

  private

  def expand_wildcard(step = 1)
    @range.step(step).to_a
  end

  def expand_list(field, step = 1)
    field.split(',').flat_map { |f| expand(f.strip, step) }
  end

  def expand_range(field, step = 1)
    if step?(field)
      base, step_part = field.split('/')
      step_value = step_part.to_i

      if range?(base)
        start_range, end_range = base.split('-').map(&:strip).map { |f| convert_to_number(f) }
        (start_range..end_range).step(step_value).to_a
      else
        base_value = convert_to_number(base)
        (base_value..@range.end).step(step_value).select { |value| @range.include?(value) }
      end
    else
      start_range, end_range = field.split('-').map(&:strip).map { |f| convert_to_number(f) }
      (start_range..end_range).step(step).to_a
    end
  end

  def expand_step(field)
    base, step_part = field.split('/')
    step_value = step_part.to_i

    if wildcard?(base)
      expand_wildcard(step_value)
    else
      base_values = if range?(base)
                      expand_range(base)
                    else
                      [convert_to_number(base)]
                    end

      base_values.flat_map do |base_value|
        (base_value..@range.end).step(step_value).select { |value| @range.include?(value) }
      end.uniq
    end
  end

  def wildcard?(field)
    field == '*'
  end

  def list?(field)
    field.include?(',')
  end

  def range?(field)
    field.include?('-')
  end

  def step?(field)
    field.include?('/')
  end

  def convert_to_number(value)
    month_map = {
      'JAN' => 1, 'FEB' => 2, 'MAR' => 3, 'APR' => 4,
      'MAY' => 5, 'JUN' => 6, 'JUL' => 7, 'AUG' => 8,
      'SEP' => 9, 'OCT' => 10, 'NOV' => 11, 'DEC' => 12
    }

    day_map = {
      'SUN' => 0, 'MON' => 1, 'TUE' => 2, 'WED' => 3,
      'THU' => 4, 'FRI' => 5, 'SAT' => 6
    }

    Integer(value)
  rescue ArgumentError
    value_upcased = value.upcase
    month_map.fetch(value_upcased,
                    day_map.fetch(value_upcased, nil)) || raise("Invalid value: '#{value}' for #{@field_name}.")
  end

  def validate_value_in_range(value)
    return if @range.include?(value)

    raise "Invalid value '#{value}' for #{@field_name}. Expected a value within the range #{@range}."
  end
end
