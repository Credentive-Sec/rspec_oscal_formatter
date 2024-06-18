# frozen_string_literal: true

require 'rspec'
require 'date'
require 'pathname'

Dir[File.join(__dir__, "rspec_oscal_formatter", "*.rb")].each { |file| require file }

# To format the output of Rspec tests as OSCAL Assessment Plans and Assessment Results
module RSpec
  module RSpecOscalFormatter
    class Error < StandardError; end

    # Core class for the formatter
    class Formatter
      RSpec::Core::Formatters.register self, :example_finished

      OUTPUT_DIRECTORY = Pathname.new('/tmp/oscal_outputs').freeze # TODO: should be a property

      def initialize(output)
        @output = output
      end

      # Generate a timestamped directory to save the file
      def create_output_directory
        example_out_dir = OUTPUT_DIRECTORY.join(DateTime.now.iso8601)
        # We should raise an exception here if we can't create the directory
        example_out_dir.mkpath unless example_out_dir.exist? && example_out_dir.directory?
        example_out_dir
      end

      def example_finished(notification)
        metadata = SpecMetaDataParser.new(notification.example)

        out_dir = create_output_directory

        out_dir.join("#{metadata.control_id}-assessment-plan.json").open('w').write(
          CreateAssessmentPlan.new(metadata).to_json,
        )

        out_dir.join("#{metadata.control_id}-assessment-result.json").open('w').write(
          CreateAssessmentResult.new(metadata).to_json,
        )
      end
    end
  end
end
