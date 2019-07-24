module SerializersBenchmark
  module Helpers
    def setup_for(opts = {})
      {
        created_at: Time.now.to_s,
        runtime: TIME[:time],
        warmup: TIME[:warmup],
      }.merge(opts)
    end
  end
end
