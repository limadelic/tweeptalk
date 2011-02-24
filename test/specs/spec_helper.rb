require 'rubygems'
require 'rr'
require "rspec"
require File.dirname(__FILE__) + '/../../lib/tweeptalk'

RSpec.configure do |c|
  c.mock_framework = :rr
end

