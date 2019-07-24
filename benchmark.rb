require 'pathname'
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require_relative 'benchmark-ips/custom_compare'
require_relative 'benchmark-memory/custom_io_output'

require_relative 'lib/speed'
require_relative 'lib/memory'
require_relative 'lib/helpers'
require_relative 'lib/results'

include SerializersBenchmark::Helpers

[:models, :serializers].each do |dir|
  Dir[
    Pathname(
      File.expand_path(File.dirname(__FILE__))
    ).join("#{dir}/**/*.rb")
  ].each { |f| require_relative f }
end

AMOUNTS = [1, 10, 20]
TIME = {time: 10, warmup: 1}

AMOUNTS.each do |collection_size|
  setup = setup_for(collection_size: collection_size)
  Results.instance << setup
  SerializersBenchmark::Memory.new(setup).run!
  SerializersBenchmark::Speed.new(setup).run!
end

File.write("results.yaml", Results.instance.to_yaml)
