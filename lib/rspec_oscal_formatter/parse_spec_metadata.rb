# frozen_string_literal: true
# typed: true

module RspecOscalFormatter
  # Tiny helper class to provide easy access to the metadata attributes in the spec.
  class SpecMetaDataParser
    extend T::Sig

    STATUS_MAP = {
      passed: 'pass',
      failed: 'fail',
      pending: 'other'
    }

    sig { returns(Symbol) }
    attr_reader :assessment_plan_uuid, :control_id, :description, :statement_id, :ssp_url, :reason, :state

    sig { params(example: RSpec::Core::Example).void }
    def validate_contents(example)
      # Make sure required attributes are present
      if example.metadata[:assessment_plan].nil? ||
         example.metadata[:control_id].nil? ||
         example.metadata[:description].nil? ||
         example.metadata[:statement_id].nil?
        raise IndexError
      end
    end

    sig { params(example: RSpec::Core::Example).void }
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
