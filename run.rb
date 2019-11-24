require 'pathname'
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require_relative 'benchmark-ips/custom_compare'
require_relative 'benchmark-memory/custom_io_output'


[:models, :serializers, :lib].each do |dir|
  Dir[
    Pathname(
      File.expand_path(File.dirname(__FILE__))
    ).join("#{dir}/**/*.rb")
  ].each { |f| require_relative f }
end
include SerializersBenchmark::Helpers

AMOUNTS = [10, 25, 50, 100]
TIME = {time: 500, warmup: 100}

AMOUNTS.each do |collection_size|
  users = collection_size.times.map{User.new}

  setup = setup_for(collection_size: collection_size)
  Results.instance << setup
  SerializersBenchmark::Memory.new(setup).run!(users)
  SerializersBenchmark::Speed.new(setup).run!(users)
end

File.write("results.yaml", Results.instance.to_yaml)

SerializersBenchmark::Graph.new(Results.instance).generate!
