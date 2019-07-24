require 'singleton'
require 'yaml'

class Results
  include Singleton

  def initialize
    @internal = []
  end

  def create(setup = {})
    @internal << setup
  end
  alias << create

  def append_speed_data(data = {})
    @internal.last[:data] = {} if @internal.last[:data].nil?
    @internal.last[:data][:speed] = data
  end

  def append_memory_data(data = {})
    @internal.last[:data] = {} if @internal.last[:data].nil?
    @internal.last[:data][:memory] = data
  end

  def to_h
    @internal
  end

  def to_yaml
    @internal.to_yaml
  end
end

