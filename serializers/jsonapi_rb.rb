class Serializers
  class JsonapiRb
    class UserSerializer < JSONAPI::Serializable::Resource
      type 'user'

      attributes(*User.model_attributes)
      #has_many :microposts
      #has_many :addresses
    end

    class MicropostSerializer < JSONAPI::Serializable::Resource
      type 'micropost'

      attributes(*Micropost.model_attributes)
    end

    class AddressSerializer < JSONAPI::Serializable::Resource
      type 'address'

      attributes(*Address.model_attributes)
    end
  end
end
