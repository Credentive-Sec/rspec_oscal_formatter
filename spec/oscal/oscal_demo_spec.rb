# frozen_string_literal: true

require 'rspec'
require_relative '../../lib/rspec_oscal_formatter'

RSpec.configure do |config|
  config.add_formatter RSpec::RspecOscalFormatter::Formatter
end

RSpec.describe 'Demonstrate Oscal Features' do
  it 'demonstrates how to create an assessment plan and assessment result with a test case',
     # The formatter relies on custom metadata to generate the asssessment plan and results
     # control_id: control ID corresponding to the catalog control you are testing
     # statement_id: statement ID coreesponding to the specific statement within the control
     # assessment_plan_uuid: A UUID to insert into the assessemnt plan.
     # Note that the The assessment plan UUID will only change when the test changes,
     # but a result UUID is calcluated for every new test run
     control_id: 'test-control', statement_id: 'test-statement',
     assessment_plan_uuid: '8bc60068-fabc-4347-823f-d31c7dbc3506' do
    expect(true).to be true
  end
end
