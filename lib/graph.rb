require 'gruff'

module SerializersBenchmark
  class Graph
    attr_reader :results, :opts

    def initialize(results, opts = {})
      @results = results
      @opts = OpenStruct.new(opts)
    end

    def generate!
      memory_graph.write("#{opts.memory_file || "memory"}.png")

      speed_graph.write("#{opts.speed_file || "speed"}.png")
    end

    def memory_graph
      g = Gruff::Line.new
      g.title = opts.memory_title || "Memory consumption"
      g.labels = labels
      memory_ratio.each do |label, values|
        g.data(
          label, values
        )
      end

      return g
    end

    def speed_graph
      g = Gruff::Line.new
      g.title = opts.speed_title || "Speed"
      g.labels = labels
      speed_ratio.each do |label, values|
        g.data(
          label, values
        )
      end

      return g
    end

    def labels
      hash = {}
      results.each_with_index{|entry, index|
        hash[index] = entry[:collection_size]
      }

      return hash
    end

    def memory_allocated
      results.map{|s|
        s.dig(:data,:memory)
      }.map{|s|
        s
      }.inject({}){|memo, e|
        e.each{|k, v|
          if memo[k].nil?
            memo[k] = [v.dig(:memory, :allocated)]
          else
            memo[k] << v.dig(:memory, :allocated)
          end
        }
        memo
      }
    end

    def memory_ratio
      results.map{|s|
        s.dig(:data,:memory)
      }.map{|s|
        s
      }.inject({}){|memo, e|
        e.each{|k, v|
          if memo[k].nil?
            memo[k] = [v.dig(:ratio)]
          else
            memo[k] << v.dig(:ratio)
          end
        }
        memo
      }
    end

    def speed_ips
      results.map{|s|
        s.dig(:data,:speed)
      }.map{|s|
        s
      }.inject({}){|memo, e|
        e.each{|k, v|
          if memo[k].nil?
            memo[k] = [v.dig(:central_tendency)]
          else
            memo[k] << v.dig(:central_tendency)
          end
        }
        memo
      }
    end

    def speed_ratio
      results.map{|s|
        s.dig(:data,:speed)
      }.map{|s|
        s
      }.inject({}){|memo, e|
        e.each{|k, v|
          if memo[k].nil?
            memo[k] = [v.dig(:slowdown)]
          else
            memo[k] << v.dig(:slowdown)
          end
        }
        memo
      }
    end

=begin
    class MemoryEntry
      attr_reader :entry, :data
      def initialize(entry)
        @entry = entry
        @data = Data.new(entry.dig(:data, :memory))
      end


      def title
        "Collection size: #{collection_size}" 
      end

      def method_missing(meth, *args)
        return super if args.any? || !entry.key?(meth)

        entry[meth.to_s.to_sym]
      end
    end

    class Data
      attr_reader :data
      def initialize(data)
        @data = data
      end

      def method_missing(meth, *args)
        return super if args.any? || !data.key?(meth)

        data[meth.to_s.to_sym]
      end
    end

    def generate!
      @results.each do
      end
    end
=end
  end
end

