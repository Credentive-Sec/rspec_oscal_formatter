# typed: true
# frozen_string_literal: true

require 'Date'
require_relative '../oscal'

module RspecOscalFormatter
  # Create an assessment plan from the metadata and template
  class CreateAssessmentPlan
    extend T::Sig

    sig { returns(Hash) }
    def build_ap_metadata_block
      {
        title: "Automated Testing Plan for login.gov. It #{@metadata.description}",
        last_modified: DateTime.now.iso8601,
        version: DateTime.now.iso8601,
        oscal_version: '1.1.2'
      }
    end

    sig { returns(Hash) }
    def make_reviewed_controls
      {
        control_selections: [
          {
            control_id: @metadata.control_id,
            statement_ids: [@metadata.statement_id]
          }
        ]
      }
    end

    sig { params(metadata: SpecMetaDataParser).void }
    def initialize(metadata)
      @metadata = metadata

      @assessment_plan = Oscal::AssessmentPlan::AssessmentPlan.new(
        {
          uuid: @metadata.assessment_plan_uuid,
          metadata: build_ap_metadata_block,
          import_ssp: { href: './assessment_plan.json' },
          reviewed_controls: make_reviewed_controls

        }
      )
    end

    sig { returns(Oscal::AssessmentPlan::AssessmentPlan) }
    def get
      @assessment_plan
    end
  end
end
