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

users = 1.times.map{User.new}
fast_jsonapi = Serializers::FastJsonapi::UserSerializer.new(users, {
  include: [:microposts, :addresses]
}).serializable_hash

jsonapi_rb_renderer = JSONAPI::Serializable::Renderer.new
jsonapi_rb = jsonapi_rb_renderer.render(users, {
  class: {
    User: Serializers::JsonapiRb::UserSerializer,
    Micropost: Serializers::JsonapiRb::MicropostSerializer,
    Address: Serializers::JsonapiRb::AddressSerializer
  },
  include: [:microposts, :addresses]
})

simple_ams = SimpleAMS::Renderer::Collection.new(users, {
  serializer: Serializers::SimpleAMS::UserSerializer,
}).as_json

ams = ActiveModelSerializers::SerializableResource.new(users, {
  adapter: :json_api,
  each_serializer: Serializers::AMS::UserSerializer,
  key_transform: :unaltered,
  include: [:microposts, :addresses]
}).as_json

binding.pry
