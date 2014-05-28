module Cranium::Logging

  def record_metric(name, value)
    log :info, "[metrics/#{name}] #{value}"
  end



  def log(level, message)
    Cranium.configuration.loggers.each do |logger|
      logger.send level, message
    end
  end

end
