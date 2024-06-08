# frozen_string_literal: true
# typed: true

module RSpec
  module RspecOscalFormatter
    # Tiny helper class to provide easy access to the metadata attributes in the spec.
    class SpecMetaDataParser
      STATUS_MAP = {
        passed: 'pass',
        failed: 'fail',
        pending: 'other'
      }

      attr_reader :assessment_plan_uuid, :control_id, :description, :statement_id, :ssp_url, :reason,
                  :state

      def validate_contents(metadata)
        # Make sure required attributes are present
        if metadata[:assessment_plan_uuid].nil? ||
           metadata[:control_id].nil? ||
           metadata[:description].nil? ||
           metadata[:statement_id].nil?
          raise IndexError
        end
      end

      def initialize(example)
        validate_contents(example.metadata) # TODO: - figure out a way to dump out if metadata isn't complete
        @assessment_plan_uuid = example.metadata[:assessment_plan_uuid]
        @control_id = example.metadata[:control_id]
        @description = example.metadata[:description]
        @statement_id = example.metadata[:statement_id]
        @reason = STATUS_MAP[example.execution_result.status]
        @state = @reason == 'pass' ? 'satisfied' : 'not-satisfied'
      end
    end
  end
end
