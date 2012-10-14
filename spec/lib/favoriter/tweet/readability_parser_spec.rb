require 'spec_helper'

require 'em-synchrony'
require 'em-synchrony/em-http'
require 'em-synchrony/fiber_iterator'

describe 'Favoriter::Tweet::ReadabilityParser' do
  let(:url) { 'http://example.com'}
  let(:parser) { Favoriter::Tweet::ReadabilityParser.new(url) }

  subject { parser }

  before do
    Favoriter::Tweet::ReadabilityParser.token = 'token'
  end

  describe '#content' do
    it 'should hit Readability API' do
      EventMachine::HttpRequest.stub(:new).and_return(double('HttpRequest', get: double('getter', response: 'response')))

      EventMachine::HttpRequest
        .should_receive(:new)
        .with("https://readability.com/api/content/v1/parser?max_pages=1&token=token&url=http%3A%2F%2Fexample.com")

      parser.content
    end

    describe 'should be parsed', use_vcr_cassette('readability') do
      let(:result) do
        result = nil

        EM.synchrony do
          EM::Synchrony::FiberIterator.new([url], 1).each do |url|
            result = Favoriter::Tweet::ReadabilityParser.new(url).content
          end

          EM.stop
        end

        result
      end

      subject { result }

      it { should be_kind_of(Hash) }
      it { should include('url', 'title', 'lead_image_url', 'excerpt', 'word_count') }
    end
  end
end