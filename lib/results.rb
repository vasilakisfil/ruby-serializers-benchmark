require 'singleton'
require 'yaml'

class Results
  include Singleton

  def initialize
    @internal = []
  end

  def append_speed_data(data = {})
    @internal.last[:data] = {} if @internal.last[:data].nil?
    @internal.last[:data][:speed] = data
  end

  def append_memory_data(data = {})
    @internal.last[:data] = {} if @internal.last[:data].nil?
    @internal.last[:data][:memory] = data
  end

  def method_missing(meth, *args, &block)
    if @internal.respond_to?(meth)
      @internal.send(meth, *args, &block)
    else
      super
    end
  end

end

