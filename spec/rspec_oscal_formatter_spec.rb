# frozen_string_literal: true

require_relative '../lib/rspec_oscal_formatter'

RSpec.describe RSpecOscalFormatter do
  it 'has a version number' do
    expect(RSpecOscalFormatter::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end
end
