require 'pathname'
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
[:models, :serializers].each do |dir|
  Dir[
    Pathname(
      File.expand_path(File.dirname(__FILE__))
    ).join("#{dir}/**/*.rb")
  ].each { |f| require_relative f }
end

#AMOUNTS = [1, 10, 50, 100]
#AMOUNTS = [1, 5, 10, 20, 40]
AMOUNTS = [10]
TIME = {time: 30, warmup: 10}
=begin
AMOUNTS.each do |num|
  users = num.times.map{User.new}
  puts "#{num} of records"
  Benchmark.memory do |x|

    x.report("FastJsonapi") {
      Serializers::FastJsonapi::UserSerializer.new(users, {
        include: [:microposts, :address]
      }).serializable_hash
    }

    x.report("JsonapiRb") {
      jsonapi_rb_renderer = JSONAPI::Serializable::Renderer.new
      jsonapi_rb_renderer.render(users, {
        class: {
          User: Serializers::JsonapiRb::UserSerializer,
          Micropost: Serializers::JsonapiRb::MicropostSerializer,
          Address: Serializers::JsonapiRb::AddressSerializer
        },
        include: [:microposts, :address]
      })
    }

    x.report("SimpleAMS") {
      SimpleAMS::Renderer::Collection.new(users, {
        serializer: Serializers::SimpleAMS::UserSerializer,
      }).as_json
    }

    x.report("AMS") {
      ActiveModelSerializers::SerializableResource.new(users, {
        adapter: :json_api,
        each_serializer: Serializers::AMS::UserSerializer,
        key_transform: :unaltered,
        include: [:microposts, :address]
      }).as_json
    }

    # Compare the iterations per second of the various reports!
    x.compare!
  end
  puts "\n"
end
=end

AMOUNTS.each do |num|
  users = num.times.map{User.new}
  puts "#{num} of records"
  Benchmark.ips do |x|

    x.config(time: TIME[:time], warmup: TIME[:warmup])

    x.report("FastJsonapi") {
      Serializers::FastJsonapi::UserSerializer.new(users, {
        include: [:microposts]
      }).serializable_hash
    }

    x.report("JsonapiRb") {
      jsonapi_rb_renderer = JSONAPI::Serializable::Renderer.new
      jsonapi_rb_renderer.render(users, {
        class: {
          User: Serializers::JsonapiRb::UserSerializer,
          Micropost: Serializers::JsonapiRb::MicropostSerializer,
          #Address: Serializers::JsonapiRb::AddressSerializer
        },
        include: [:microposts]
      })
    }

    x.report("SimpleAMS") {
      SimpleAMS::Renderer::Collection.new(users, {
        serializer: Serializers::SimpleAMS::UserSerializer,
      }).as_json
    }

    x.report("AMS") {
      ActiveModelSerializers::SerializableResource.new(users, {
        adapter: :json_api,
        each_serializer: Serializers::AMS::UserSerializer,
        key_transform: :unaltered,
        include: [:microposts]
      }).as_json
    }

    # Compare the iterations per second of the various reports!
    x.compare!
  end
  puts "\n"
end
