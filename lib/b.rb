require File.expand_path("../../config/environment", __FILE__)
require 'benchmark'

AwesomePrint.defaults = {
  raw: true,
  limit: true
}

user = User.last
stream = Favoriter::Stream.new(user)

Benchmark.bm do |x|
  x.report('fetch') { stream.fetch }
end

ap stream.tweets