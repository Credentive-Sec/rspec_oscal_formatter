# frozen_string_literal: true

require 'date'
require 'random/formatter'

require 'oscal'

module RSpec
  module RSpecOscalFormatter
    # Creates an Assessment Result from an RSpec Unit Test Run
    class CreateAssessmentResult
      def initialize(metadata)
        @assessment_result = Oscal::AssessmentResult::AssessmentResult.new(
          uuid: Random.uuid,
          metadata: build_metadata_block,
          import_ap: { href: './exported_ap.json' }, # This is not correct. Should be dynamic.
          results: create_results_block(metadata),
        )
      end

      def build_metadata_block
        {
          title: 'Test Result for login.gov.',
          last_modified: DateTime.now.iso8601,
          version: DateTime.now.iso8601,
          oscal_version: '1.1.2',
        }
      end

      def create_results_block(metadata)
        # TODO: - multiple results per test?
        [{
          uuid: Random.uuid,
          title: metadata.description,
          description: metadata.description,
          start: DateTime.now.iso8601,
          reviewed_controls: create_reviewed_controls(metadata),
          observations: [create_observations(metadata)],
          findings: [create_findings(metadata)],
        }]
      end

      def create_reviewed_controls(metadata)
        {
          control_selections: [
            {
              include_controls: [
                { control_id: metadata.control_id },
              ],
            },
          ],
        }
      end

      def create_observations(metadata)
        {
          uuid: Random.uuid,
          title: metadata.description,
          description: metadata.description,
          methods: ['TEST'],
          collected: DateTime.now.iso8601,
        }
      end

      def create_findings(metadata)
        {
          uuid: Random.uuid,
          title: 'Automated Test Outcome',
          description: metadata.description,
          target: create_target(metadata),
        }
      end

      def create_target(metadata)
        {
          type: 'statement-id',
          target_id: metadata.statement_id,
          status: {
            state: metadata.state,
            reason: metadata.reason,
          },
        }
      end

      def get
        @assessment_result
      end

      def to_json(*_args)
        @assessment_result.to_json
      end
    end
  end
end
