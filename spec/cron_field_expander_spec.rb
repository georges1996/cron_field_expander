# frozen_string_literal: true

# spec/cron_field_expander_spec.rb
require 'rspec'
require_relative '../lib/cron_field_expander'

RSpec.describe CronFieldExpander do
  let(:range) { (0..59) }
  let(:field_name) { 'minute' }

  subject { CronFieldExpander.new(range, field_name) }

  describe '#expand' do
    it 'expands a wildcard (*) correctly' do
      expect(subject.expand('*')).to eq((0..59).to_a)
    end

    it 'expands a list (e.g., "1,2,3") correctly' do
      expect(subject.expand('1,2,3')).to eq([1, 2, 3])
    end

    it 'expands a range (e.g., "1-5") correctly' do
      expect(subject.expand('1-5')).to eq([1, 2, 3, 4, 5])
    end

    it 'expands a range with a step (e.g., "0-20/2") correctly' do
      expect(subject.expand('0-20/2')).to eq([0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20])
    end

    it 'expands a step with a base (e.g., "*/15") correctly' do
      expect(subject.expand('*/15')).to eq([0, 15, 30, 45])
    end

    it 'expands a step with a range base (e.g., "1-10/3") correctly' do
      expect(subject.expand('1-10/3')).to eq([1, 4, 7, 10])
    end

    it 'expands a single value correctly (e.g., "5")' do
      expect(subject.expand('5')).to eq([5])
    end

    it 'raises an error for a value out of range (e.g., "60")' do
      expect do
        subject.expand('60')
      end.to raise_error("Invalid value '60' for minute. Expected a value within the range 0..59.")
    end

    it 'raises an error for an empty string' do
      expect { subject.expand('') }.to raise_error("Invalid value: '' for minute.")
    end

    it 'expands a step with a wildcard in a base (e.g., "*/5") correctly' do
      expect(subject.expand('*/5')).to eq([0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55])
    end
  end
end
