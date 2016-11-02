require 'docker'
require 'serverspec'
require 'should_not/rspec'

set :os, family: :alpine
set :backend, :docker

$project_root = File.expand_path(File.join(__FILE__, '..', '..','..'))

puts $project_root

RSpec.configure do |config|
 config.color = true
 config.tty = true
 config.formatter = :documentation # :progress, :html, :textmate
 # enforce expect syntax
 config.expect_with :rspec do |c|
   c.syntax = :expect
 end
end
