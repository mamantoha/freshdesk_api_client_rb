# frozen_string_literal: true

require 'rake/testtask'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

if defined?(RSpec)
  desc 'Run specs'
  RSpec::Core::RakeTask.new('spec') do |t|
    t.pattern = 'spec/core/**/*_spec.rb'
  end

  desc 'Default: run specs.'
  task default: 'spec'
end
