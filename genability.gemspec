# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{genability}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matthew Solt"]
  s.date = %q{2011-06-28}
  s.description = %q{Ruby client for the Genability power pricing and related APIs - learn more at https://developer.genability.com}
  s.email = %q{mattsolt@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Gemfile",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "lib/genability.rb",
    "spec/genability_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/activefx/genability}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Ruby client for the Genability API}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<faraday>, ["~> 0.6"])
      s.add_runtime_dependency(%q<faraday_middleware>, ["~> 0.6"])
      s.add_runtime_dependency(%q<hashie>, ["~> 1.0.0"])
      s.add_runtime_dependency(%q<multi_json>, ["~> 1.0.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.6.0"])
      s.add_development_dependency(%q<yard>, ["~> 0.7.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.2"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.4"])
      s.add_development_dependency(%q<vcr>, ["~> 1.10.0"])
      s.add_development_dependency(%q<webmock>, ["~> 1.6.0"])
    else
      s.add_dependency(%q<faraday>, ["~> 0.6"])
      s.add_dependency(%q<faraday_middleware>, ["~> 0.6"])
      s.add_dependency(%q<hashie>, ["~> 1.0.0"])
      s.add_dependency(%q<multi_json>, ["~> 1.0.0"])
      s.add_dependency(%q<rspec>, ["~> 2.6.0"])
      s.add_dependency(%q<yard>, ["~> 0.7.0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.2"])
      s.add_dependency(%q<simplecov>, ["~> 0.4"])
      s.add_dependency(%q<vcr>, ["~> 1.10.0"])
      s.add_dependency(%q<webmock>, ["~> 1.6.0"])
    end
  else
    s.add_dependency(%q<faraday>, ["~> 0.6"])
    s.add_dependency(%q<faraday_middleware>, ["~> 0.6"])
    s.add_dependency(%q<hashie>, ["~> 1.0.0"])
    s.add_dependency(%q<multi_json>, ["~> 1.0.0"])
    s.add_dependency(%q<rspec>, ["~> 2.6.0"])
    s.add_dependency(%q<yard>, ["~> 0.7.0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.2"])
    s.add_dependency(%q<simplecov>, ["~> 0.4"])
    s.add_dependency(%q<vcr>, ["~> 1.10.0"])
    s.add_dependency(%q<webmock>, ["~> 1.6.0"])
  end
end
