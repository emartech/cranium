module Cranium::Logging

  def record_metric(name, value)
    log :info, "[metrics/#{name}] #{value}"
  end



  def record_timer(name, start_time, end_time)
    record_metric name, "#{end_time - start_time}s"
  end



  def log(level, message)
    Cranium.configuration.loggers.each do |logger|
      logger.send level, message
    end
  end

end
