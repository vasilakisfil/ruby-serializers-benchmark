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

=begin
def time_method(method=nil, *args)
  beginning_time = Time.now
  if block_given?
    s = yield
  else
    self.send(method, args)
  end
  end_time = Time.now
  puts "Time elapsed #{(end_time - beginning_time)*1000} milliseconds"
  return s
end
=end

users = 1000.times.map{User.new}
result = RubyProf.profile do
  SimpleAMS::Renderer::Collection.new(users, {
    serializer: Serializers::SimpleAMS::UserSerializer,
    includes: []
  }).as_json
end
printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT)
