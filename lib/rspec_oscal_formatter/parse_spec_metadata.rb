# frozen_string_literal: true
# typed: true

module RspecOscalFormatter
  # Tiny helper class to provide easy access to the metadata attributes in the spec.
  class SpecMetaDataParser
    extend T::Sig

    sig { returns(Symbol) }
    attr_reader :assessment_plan_uuid, :control_id, :description, :statement_id, :ssp_url

    sig { params(metadata_hash: Hash).void }
    def validate_contents(metadata_hash)
      # Make sure required attributes are present
    end

    sig { params(metadata_hash: Hash).void }
    def initialize(metadata_hash)
      validate_contents(metadata_hash)
      @assessment_plan_uuid = metadata_hash[:assessment_plan_uuid]
      @control_id = metadata_hash[:control_id]
      @description = metadata_hash[:description]
      @statement_id = metadata_hash[:statement_id]
    end
  end
end
