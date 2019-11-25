module SerializersBenchmark
  class Speed
    attr_reader :setup
    def initialize(setup)
      @setup = setup
      @setup.each do |key, value|
        define_singleton_method(key) { value }
      end
    end

    def run!(users)
      puts "#{collection_size} of records"
      Benchmark.ips do |x|
        x.config(time: TIME[:time], warmup: TIME[:warmup])

        x.report("FastJsonapi") {
          Serializers::FastJsonapi::UserSerializer.new(users, {
            include: [:microposts, :address]
          }).serializable_hash
        }

        x.report("JsonapiRb") {
          jsonapi_rb_renderer = JSONAPI::Serializable::Renderer.new
          jsonapi_rb_renderer.render(users, {
            class: {
              User: Serializers::JsonapiRb::UserSerializer,
              Micropost: Serializers::JsonapiRb::MicropostSerializer,
              #Address: Serializers::JsonapiRb::AddressSerializer
            },
            include: [:microposts, :address]
          })
        }

        x.report("SimpleAMS") {
          SimpleAMS::Renderer::Collection.new(users, {
            serializer: Serializers::SimpleAMS::UserSerializer,
            include: [:microposts, :address],
          }).as_json
        }

        x.report("AMS") {
          ActiveModelSerializers::SerializableResource.new(users, {
            adapter: :json_api,
            each_serializer: Serializers::AMS::UserSerializer,
            key_transform: :unaltered,
            include: [:microposts, :address]
          }).as_json
        }

        # Compare the iterations per second of the various reports!
        x.compare!
      end
      puts "\n"
    end
  end
end

