class Serializers
  class FastJsonapi
    class UserSerializer
      include ::FastJsonapi::ObjectSerializer

      set_type :user  # optional
      set_id :id # optional
      attributes(*User.model_attributes)
      #has_many :microposts
      #has_many :addresses
    end

    class MicropostSerializer
      include ::FastJsonapi::ObjectSerializer

      set_type :micropost  # optional
      set_id :id # optional
      attributes(*Micropost.model_attributes)
    end

    class AddressSerializer
      include ::FastJsonapi::ObjectSerializer

      set_type :address  # optional
      set_id :id # optional
      attributes(*Address.model_attributes)
    end
  end
end
