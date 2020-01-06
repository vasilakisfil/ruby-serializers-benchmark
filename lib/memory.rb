module SerializersBenchmark
  class Memory
    attr_reader :setup
    def initialize(setup)
      @setup = setup
    end

    def run!(users)
      puts "#{setup.collection_size} of records"
      Benchmark.memory do |x|

        x.report("FastJsonapi") {
          Serializers::FastJsonapi::UserSerializer.new(users, {
            include: setup.relations
          }).serializable_hash
        }

        x.report("JsonapiRb") {
          jsonapi_rb_renderer = JSONAPI::Serializable::Renderer.new
          jsonapi_rb_renderer.render(users, {
            class: {
              User: Serializers::JsonapiRb::UserSerializer,
              Micropost: Serializers::JsonapiRb::MicropostSerializer,
              Address: Serializers::JsonapiRb::AddressSerializer
            },
            include: setup.relations
          })
        }

        x.report("SimpleAMS") {
          SimpleAMS::Renderer::Collection.new(users, {
            serializer: Serializers::SimpleAMS::UserSerializer,
            includes: setup.relations,
          }).as_json
        }

        x.report("AMS") {
          ActiveModelSerializers::SerializableResource.new(users, {
            adapter: :json_api,
            each_serializer: Serializers::AMS::UserSerializer,
            key_transform: :unaltered,
            include: setup.relations
          }).as_json
        }

        # Compare the iterations per second of the various reports!
        x.compare!
      end
      puts "\n"
    end

    def run_single!(user)
      puts "single record"

      Benchmark.memory do |x|
        x.report("FastJsonapi") {
          Serializers::FastJsonapi::UserSerializer.new(user, {
            include: setup.relations
          }).serializable_hash
        }

        x.report("JsonapiRb") {
          jsonapi_rb_renderer = JSONAPI::Serializable::Renderer.new
          jsonapi_rb_renderer.render(user, {
            class: {
              User: Serializers::JsonapiRb::UserSerializer,
              Micropost: Serializers::JsonapiRb::MicropostSerializer,
              Address: Serializers::JsonapiRb::AddressSerializer
            },
            include: setup.relations
          })
        }

        x.report("SimpleAMS") {
          SimpleAMS::Renderer.new(user, {
            serializer: Serializers::SimpleAMS::UserSerializer,
            includes: setup.relations,
          }).as_json
        }

        x.report("AMS") {
          ActiveModelSerializers::SerializableResource.new(user, {
            adapter: :json_api,
            each_serializer: Serializers::AMS::UserSerializer,
            key_transform: :unaltered,
            include: setup.relations
          }).as_json
        }

        # Compare the iterations per second of the various reports!
        x.compare!
      end
      puts "\n"
    end
  end
end

