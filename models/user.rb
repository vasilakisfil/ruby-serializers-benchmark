class User
  class << self
    def model_attributes
      @attributes ||= self.instance_methods(false) - excluded_methods
    end

    def excluded_methods
      relations.map(&:name) + ids + [:read_attribute_for_serialization]
    end

    def relation_names
      @relations ||= relations.map(&:name)
    end

    def relations
      [
        OpenStruct.new(
          name: :microposts, type: :micropost#, options: {serializer: Serializers::MicropostSerializer}
        ),
        OpenStruct.new(
          name: :addresses, type: :address#, options: {serializer: Serializers::MicropostSerializer}
        ),
=begin
        OpenStruct.new(
          name: :address, type: :address #options: {serializer: AddressSerializer}
        ),
        OpenStruct.new(
          name: :followers, type: :follower#, options: {serializer: UserSerializer}
        ),
        OpenStruct.new(
          name: :followings, type: :following options: {serializer: UserSerializer}
        ),
=end
      ]
    end

    def ids
      relations.map{|s| "#{s.type}_ids".to_sym}
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

  def name
    @name ||= Faker::Name.name
  end

  def email
    @email ||= Faker::Internet.email
  end

  def admin
    return @admin if defined?(@admin)

    @admin = [false, true].sample
    return @admin
  end

  def created_at
    @cretated_at ||= Faker::Date.backward(days: 100)
  end

  def updated_at
    @updated_at ||= Faker::Date.between(from: created_at, to: Date.today)
  end

  def token
    @token ||= SecureRandom.hex
  end
  def followers_count
    @followers_count ||= 10
  end

  def followings_count
    @followers_count ||= 10
  end

  def microposts
    @microposts ||= 10.times.map{Micropost.new}
  end

  def micropost_ids
    @micropost_ids ||= microposts.map(&:id)
  end

  def addresses
    @address ||= 10.times.map{Address.new}
  end

  def address_ids
    @address_ids ||= addresses.map(&:id)
  end

=begin
  def followers
    @followers ||= 50.times.map{User.new}
  end
  def followings
    @followings ||= rand(10).times.map{User.new}
  end
=end
end

