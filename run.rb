require 'pathname'
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
require "active_support/core_ext/object/deep_dup"

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

AMOUNTS = [1, 5, 10, 20, 50, 100, 250]
TIME = {runtime: 500, warmup: 50}

AMOUNTS.each do |collection_size|
  users = collection_size.times.map{User.new}

  setup = OpenStruct.new(
    created_at: Time.now.to_s,
    time: TIME,
    collection_size: collection_size,
    relations: [:microposts, :addresses]
  )
  Results.instance << setup

  SerializersBenchmark::Memory.new(setup).run!(users)
  SerializersBenchmark::Speed.new(setup).run!(users)
end

File.write("results.yaml", Results.instance.to_yaml)

SerializersBenchmark::Graph.new(Results.instance, {
  memory_file: "memory",
  speed_file: "speed",
  memory_title: "Memory consumption for collection size",
  speed_title: "Speed for collection size"
}).generate!
