module Benchmark
  module Memory
    class Job
      class IOOutput
        alias _put_comparison put_comparison
        def put_comparison(comparison)
          _put_comparison(comparison)

          _report_data(comparison)
        end

        def _report_data(comparison)
          results = {}

          comparison.entries.each do |entry|
            results[entry.label.to_s] = _data_for(entry, comparison.entries[0])
          end

          Results.instance.append_memory_data(results)
        end

        def _data_for(entry, best)
          {
            name: entry.label,
            ratio: entry.allocated_memory.to_f / best.allocated_memory.to_f,
            memory: {
              allocated: entry.measurement.memory.allocated,
              retained: entry.measurement.memory.retained
            },
            objects: {
              allocated: entry.measurement.objects.allocated,
              retained: entry.measurement.objects.retained
            },
            strings: {
              allocated: entry.measurement.strings.allocated,
              retained: entry.measurement.strings.retained
            },
          }
        end
      end
    end
  end
end
