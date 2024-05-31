# typed: true
# frozen_string_literal: true

require 'rspec'
require 'random/formatter'
require 'date'
require 'pathname'
require_relative 'oscal'
require_relative 'rspec_oscal_formatter/version'

module RspecOscalFormatter
  extend T::Sig
  class Error < StandardError; end

  # Your code goes here...
  class Formatter
    extend T::Sig

    RSpec::Core::Formatters.register self, :example_finished

    sig { params(example: RSpec::Core::Example).returns(String) }
    def create_assessment_result(example)
      ar_hash = {
        uuid: Random.uuid, # Generate a new UUID everytime we run, since this is a new result
        metadata: {
          title: 'Automated Testing Results for login.gov',
          last_modified: DateTime.now.iso8601,
          version: '1.0',
          oscal_version: '1.1.2'
        },
        import_ap: { href: './exported_ap.json' },
        results: [
          {
            uuid: Random.uuid,
            title: example.metadata[:description],
            description: example.metadata[:description],
            start: DateTime.now.iso8601,
            reviewed_controls: {
              control_selections: [
                {
                  include_controls: [
                    { control_id: example.metadata[:control_id] }
                  ]
                }
              ]
            },
            observations: [
              {
                uuid: Random.uuid,
                title: example.metadata[:description],
                description: example.metadata[:description],
                methods: [
                  'TEST'
                ],
                collected: DateTime.now.iso8601
              }
            ],
            findings: [
              uuid: Random.uuid,
              title: 'Automated Test Outcome',
              description: example.metadata[:description],
              target: {
                type: 'statement-id',
                target_id: example.metadata[:statement_id],
                status: {
                  state: example.execution_result.status.to_s # :passed, :failed, :pending
                }
              }
            ]
          }
        ]
      }

      Oscal::AssessmentResult::AssessmentResult.new(ar_hash).to_json
    end

    sig { params(output: RSpec::Core::OutputWrapper).void }
    def initialize(output)
      @output = output
      output.puts output.class
      @output_directory = Pathname.new '/tmp/oscal_outputs/'
    end

    sig { params(notification: RSpec::Core::Notifications::ExampleNotification).void }
    def example_finished(notification)
      # Get the control ID from the test case metadata
      example_control_id = notification.example.metadata[:control_id]

      # Generate a timestamped directory to save the file
      example_out_dir = @output_directory.join(example_control_id).join(DateTime.now.iso8601)
      example_out_dir.mkpath unless example_out_dir.exist? && example_out_dir.directory?

      example_out_dir.join('assessment_plan.json').open('w').write(
        CreateAssessmentPlan.get(notification.example)
      )

      example_out_dir.join('assessment_result.json').open('w').write(
        create_assessment_result(notification.example)
      )
    end
  end
end
