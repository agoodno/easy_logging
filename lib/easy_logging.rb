require 'logger'

require_relative "easy_logging/version"

module EasyLogging

  class << self; attr_accessor :log_destination, :level, :formatter; end

  @log_destination = STDOUT
  @level = Logger::INFO
  @loggers = {}

  def logger
    @logger ||= EasyLogging.logger_for(self.class.name)
  end

  def self.log_destination=(dest)
    @log_destination = dest
  end

  def self.level=(level)
    @level = level
  end

private

  # Executed when the module is included. See: https://stackoverflow.com/a/5160822/2771889
  def self.included(base)
    # Class level logger method for includer class (base)
    def base.logger
      @logger ||= EasyLogging.logger_for(self)
    end
  end

  # Global, memoized, lazy initialized instance of a logger
  def self.logger_for(classname)
    @loggers[classname] ||= configure_logger_for(classname)
  end

  def self.configure_logger_for(classname)
    logger = Logger.new(log_destination)
    logger.level = level
    logger.progname = classname
    logger.formatter = formatter unless formatter.nil?
    logger
  end

end
