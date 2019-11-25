class Micropost
  class << self
    def model_attributes
      @attributes ||= self.instance_methods(false) - excluded_methods
    end

    def excluded_methods
      [:read_attribute_for_serialization]
    end
    def relations
      [
=begin
        OpenStruct.new(
          name: :user, type: :user#, options: {serializer: UserSerializer}
        ),
=end
      ]
    end

    #AMS specific
    def model_name
      @_model_name ||= ActiveModel::Name.new(self)
    end
  end

  #AMS specific
  alias :read_attribute_for_serialization :send

  def initialize(opts = {})
    @opts = opts

    #eager load
    self.class.model_attributes.each do |meth|
      self.send(meth)
    end

    #eager load
    self.class.relations.map(&:name).each do |rel|
      self.send(rel)
    end
  end

  def id
    @id ||= rand(100000)
  end

  def content
    @content ||= Faker::Lorem.paragraph
  end

  def created_at
    @cretated_at ||= Faker::Date.backward(days: 100)
  end

  def updated_at
    @updated_at ||= Faker::Date.between(from: created_at, to: Date.today)
  end

  def published_at
    @published_at ||= Faker::Date.between(from: updated_at, to: Date.today)
  end

  def likes_count
    @likes_count ||= rand(100)
  end
=begin
  def user
    @user ||= User.new
  end
=end
end
