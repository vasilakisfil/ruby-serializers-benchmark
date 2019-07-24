ActiveSupport::Notifications.unsubscribe(ActiveModelSerializers::Logging::RENDER_EVENT)

class Serializers
  class AMS
    class MicropostSerializer < ActiveModel::Serializer
      type :micropost
      attributes(*Micropost.model_attributes)
    end
    class AddressSerializer < ActiveModel::Serializer
      type :address
      attributes(*Address.model_attributes)
    end

    class UserSerializer < ActiveModel::Serializer
      type :user
      attributes(*User.model_attributes)

      #has_many :microposts, serializer: Serializers::AMS::MicropostSerializer
      #has_many :addresses, serializer: Serializers::AMS::AddressSerializer
    end
  end
end

