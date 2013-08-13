lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "instavin"

require "minitest/autorun"
require "minitest/spec"
require "mocha/setup"
require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = "test/fixtures/vcr_cassettes"
  c.hook_into :webmock
  c.default_cassette_options = { match_requests_on: [:method, :uri, :body] }
end
