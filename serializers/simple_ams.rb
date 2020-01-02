class Serializers
  class SimpleAMS
    class BaseSerializer
      include ::SimpleAMS::DSL

      adapter ::SimpleAMS::Adapters::JSONAPI
    end

    class UserSerializer < BaseSerializer
      attributes(*User.model_attributes)

      type :user
      collection :users

      has_many :microposts
      has_many :addresses
    end

    class MicropostSerializer < BaseSerializer
      attributes(*Micropost.model_attributes)

      type :micropost
      collection :microposts
    end

    class AddressSerializer < BaseSerializer
      attributes(*Address.model_attributes)

      type :address
      collection :addresses
    end
  end
end
