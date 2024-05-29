# frozen_string_literal: true
# typed: true

module RspecOscalFormatter
  class SpecMetaDataParser
    extend T::Sig
    attr_reader :assessment_plan_uuid, :control_id, :description, :statement_id

    sig { params(metadata_hash: Hash).void }
    def initialize(metadata_hash)
      if metadata_hash.keys.
      @assessment_plan_uuid = metadata_hash[:assessment_plan_uuid]
      @control_id = metadata_hash[:control_id]
      @description = metadata_hash[:description]
      @statement_id = metadata_hash[:statement_id]
    end
  end
end
