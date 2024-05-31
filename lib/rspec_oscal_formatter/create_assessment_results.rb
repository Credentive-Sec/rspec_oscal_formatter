# typed: true
# frozen_string_literal: true

require 'tapioca'
require 'date'
require 'random/formatter'

require_relative '../oscal'

module RspecOscalFormatter
  # Creates an Assessment Result from an RSpec Unit Test Run
  class CreateAssessmentResult
    extend T::Sig

    sig { params(metadata: SpecMetaDataParser).void }
    def initialize(metadata)
      @assessment_result = Oscal::AssessmentResult::AssessmentResult.new(
        uuid: Random.uuid,
        metadata: build_metadata_block,
        import_ap: { href: './exported_ap.json' },
        results: create_results_block(metadata)
      )
    end

    sig { returns(Hash) }
    def build_metadata_block
      {
        title: 'Test Result for login.gov.',
        last_modified: DateTime.now.iso8601,
        version: DateTime.now.iso8601,
        oscal_version: '1.1.2'
      }
    end

    sig { params(metadata: SpecMetaDataParser).returns(Array) }
    def create_results_block(metadata)
      # TODO: - multiple results per test?
      [{
        uuid: Random.uuid,
        title: metadata.description,
        description: metadata.description,
        start: DateTime.now.iso8601,
        reviewed_controls: create_reviewed_controls(metadata),
        observations: [create_observations(metadata)],
        findings: [create_findings(metadata)]
      }]
    end

    sig { params(metadata: SpecMetaDataParser).returns(Hash) }
    def create_reviewed_controls(metadata)
      {
        control_selections: get_include_controls(metadata)
      }
    end

    sig { params(metadata: SpecMetaDataParser).returns(Array) }
    def get_include_controls(metadata)
      [{ control_id: metadata.control_id }]
    end

    sig { params(metadata: SpecMetaDataParser).returns(Hash) }
    def create_observations(metadata)
      {
        uuid: Random.uuid,
        title: metadata.description,
        description: metadata.description,
        methods: ['TEST'],
        collected: DateTime.now.iso8601
      }
    end

    sig { params(metadata: SpecMetaDataParser).returns(Hash) }
    def create_findings(metadata)
      {
        uuid: Random.uuid,
        title: 'Automated Test Outcome',
        description: metadata.description,
        target: create_target(metadata)
      }
    end

    sig { params(metadata: SpecMetaDataParser).returns(Hash) }
    def create_target(metadata)
      {
        type: 'statement-id',
        target_id: metadata.statement_id,
        status: {
          state: metadata.state,
          reason: metadata.reason
        }
      }
    end

    sig { returns(Oscal::AssessmentPlan::AssessmentPlan) }
    def get
      @assessment_result
    end

    sig { params(_args: T.untyped).returns(String) }
    def to_json(*_args)
      @assessment_result.to_json
    end
  end
end
