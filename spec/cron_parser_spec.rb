# frozen_string_literal: true

require 'rspec'
require_relative '../lib/cron_parser'

RSpec.describe CronParser do
  describe '#parse' do
    let(:stdout) { StringIO.new }
    before { $stdout = stdout }
    after { $stdout = STDOUT }

    context 'with valid cron strings' do
      it 'parses a simple cron expression correctly' do
        cron_string = '*/5 0 1,15 * 1-5 /usr/bin/find'
        parser = CronParser.new(cron_string)

        parser.parse

        expected_output = <<~OUTPUT
          minute         0 5 10 15 20 25 30 35 40 45 50 55
          hour           0
          day of month   1 15
          month          1 2 3 4 5 6 7 8 9 10 11 12
          day of week    1 2 3 4 5
          command       /usr/bin/find
        OUTPUT

        expect(stdout.string).to eq(expected_output)
      end

      it 'parses a cron expression with all fields specified' do
        cron_string = '*/7 0 1,15 * 1-5 /usr/bin/find'
        parser = CronParser.new(cron_string)

        parser.parse

        expected_output = <<~OUTPUT
          minute         0 7 14 21 28 35 42 49 56
          hour           0
          day of month   1 15
          month          1 2 3 4 5 6 7 8 9 10 11 12
          day of week    1 2 3 4 5
          command       /usr/bin/find
        OUTPUT

        expect(stdout.string).to eq(expected_output)
      end

      it 'parses a cron expression with all fields specified' do
        cron_string = '* 0-20/2 * * * /usr/bin/find'
        parser = CronParser.new(cron_string)

        parser.parse

        expected_output = <<~OUTPUT
          minute         0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59
          hour           0 2 4 6 8 10 12 14 16 18 20
          day of month   1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
          month          1 2 3 4 5 6 7 8 9 10 11 12
          day of week    0 1 2 3 4 5 6
          command       /usr/bin/find
        OUTPUT

        expect(stdout.string).to eq(expected_output)
      end
    end

    context 'with invalid cron strings' do
      it 'raises an error for missing fields' do
        cron_string = '* * * *'
        parser = CronParser.new(cron_string)

        expect do
          parser.parse
        end.to raise_error('Invalid cron format. Please provide exactly 5 time fields and 1 command.')
      end

      it 'raises an error for invalid time fields' do
        cron_string = '*/5 25 1,15 * * /usr/bin/find'
        parser = CronParser.new(cron_string)

        expect { parser.parse }.to raise_error(/Invalid value '25' for hour. Expected a value within the range 0..23./)
      end
    end
  end
end
