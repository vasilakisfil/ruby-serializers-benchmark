module Benchmark::Compare
  alias _compare compare

  def compare(*entries)
    _compare(*entries)

    _report_data(*entries)
  end

  def _report_data(*entries)
    results = {}
    sorted = entries.sort_by{ |e| e.stats.central_tendency }.reverse

    best = sorted[0]

    sorted.each do |entry|
      results[entry.label.to_s] = _data_for(entry, best)
    end

    Results.instance.append_speed_data(results)
  end

  def _data_for(entry, best)
    {
      name: entry.label,
      central_tendency: entry.stats.central_tendency,
      ips: entry.stats.central_tendency, # for backwards compatibility
      error: entry.stats.error,
      microseconds: entry.microseconds,
      iterations: entry.iterations,
      cycles: entry.measurement_cycle,
      slowdown: entry.stats.slowdown(best.stats).first
    }
  end
end
