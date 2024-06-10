# frozen_string_literal: true

require_relative 'lib/rspec_oscal_formatter/version'

Gem::Specification.new do |spec|
  spec.name = 'rspec_oscal_formatter'
  spec.version = RspecOscalFormatter::VERSION
  spec.authors = ['Robert Sherwood']
  spec.email = ['robert.sherwood@credentive.com']

  spec.summary = 'An RSpec formatter that allows you to write security focused tests for OSCAL catalogs and produce Assessment Plans and Assessment Results.'
  spec.homepage = 'https://github.com/Credentive-Sec/rspec_oscal_formatter'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org/'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/Credentive-Sec/rspec_oscal_formatter'
  spec.metadata['changelog_uri'] = 'https://github.com/Credentive-Sec/rspec_oscal_formatter/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency 'oscal', '~> 0.2'

  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'rubocop', '~> 1.21'
  spec.add_development_dependency 'solargraph'
end
