class Address
  class << self
    def model_attributes
      @attributes ||= self.instance_methods(false) - excluded_methods
    end

    def excluded_methods
      [:read_attribute_for_serialization]
    end

    #AMS specific
    def model_name
      @_model_name ||= ActiveModel::Name.new(self)
    end
  end

  #AMS specific
  alias :read_attribute_for_serialization :send

  def initialize(opts = {})
    opts.keys.each do |key|
      self.instance_variable_set("@#{key}", opts[key])
    end

    #eager load
    self.class.model_attributes.each do |meth|
      self.send(meth)
    end
  end


  def id
    @id ||= rand(100000)
  end

  def street_name
    @street_name ||= Faker::Address.street_name
  end

  def street_number
    @street_number ||= rand(100)
  end

  def city
    @city ||= Faker::Address.city
  end

  def post_code
    @post_code ||= Faker::Address.postcode
  end

  def state
    @state ||= Faker::Address.state
  end

  def country
    @country ||= Faker::Address.country
  end

  def created_at
    @cretated_at ||= Faker::Date.backward(days: 100)
  end

  def updated_at
    @updated_at ||= Faker::Date.between(from: created_at, to: Date.today)
  end
end

