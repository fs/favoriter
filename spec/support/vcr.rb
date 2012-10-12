require 'vcr'

VCR.configure do |c|
  c.default_cassette_options = { :record => :once }
  c.allow_http_connections_when_no_cassette = false
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :fakeweb
  c.configure_rspec_metadata!
end

def use_vcr_cassette(cassette_name)
  { vcr: { cassette_name: cassette_name } }
end
