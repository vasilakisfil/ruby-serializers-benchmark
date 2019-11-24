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

users = 1.times.map{User.new}
=begin
fast_jsonapi = Serializers::FastJsonapi::UserSerializer.new(users, {
  #include: [:microposts, :addresses]
}).serializable_hash

jsonapi_rb_renderer = JSONAPI::Serializable::Renderer.new
jsonapi_rb = jsonapi_rb_renderer.render(users, {
  class: {
    User: Serializers::JsonapiRb::UserSerializer,
    #Micropost: Serializers::JsonapiRb::MicropostSerializer,
    #Address: Serializers::JsonapiRb::AddressSerializer
  },
  include: [:microposts, :addresses]
})

ams = ActiveModelSerializers::SerializableResource.new(users, {
  adapter: :json_api,
  each_serializer: Serializers::AMS::UserSerializer,
  key_transform: :unaltered,
  #include: [:microposts, :addresses]
}).as_json

=end
simple_ams = SimpleAMS::Renderer::Collection.new(users, {
  serializer: Serializers::SimpleAMS::UserSerializer,
}).as_json

binding.pry
