require 'logger'
module Logging

  def self.logger
    @logger
  end

  def self.logger=(log)
    if log
      @logger = log
    else
      puts 'logging to dev null'
      @logger = Logger.new('/dev/null')
    end
  end

  def logger
    #TODO Initialise in the instance if the class variable is not set
    Logging.logger
  end

  def log_error(error)
    logger.error { "#{error.class}: #{error.message}" }
    error.backtrace.each { |line| logger.error line }
  end
end
