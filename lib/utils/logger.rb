require 'logger'
require 'fileutils'

class CustomLogger
  LOG_DIR = './logs'.freeze
  
  @logger = nil

  def self.setup
    FileUtils.mkdir_p(LOG_DIR) unless Dir.exist?(LOG_DIR)
    
    log_file = File.join(LOG_DIR, "test_#{Time.now.strftime('%Y%m%d')}.log")
    
    @logger = Logger.new(log_file, 'daily')
    @logger.level = Logger::DEBUG
    @logger.formatter = proc do |severity, datetime, _progname, msg|
      "[#{datetime.strftime('%Y-%m-%d %H:%M:%S')}] #{severity}: #{msg}\n"
    end
    
    @logger
  end

  def self.logger
    @logger ||= setup
  end

  def self.info(message)
    logger.info(message)
    puts "[INFO] #{message}"
  end

  def self.debug(message)
    logger.debug(message)
    puts "[DEBUG] #{message}" if ENV['DEBUG'] == 'true'
  end

  def self.warn(message)
    logger.warn(message)
    puts "[WARN] #{message}"
  end

  def self.error(message)
    logger.error(message)
    puts "[ERROR] #{message}"
  end

  def self.fatal(message)
    logger.fatal(message)
    puts "[FATAL] #{message}"
  end

  def self.log_test_start(test_name)
    info("=" * 80)
    info("Starting Test: #{test_name}")
    info("=" * 80)
  end

  def self.log_test_end(test_name, status)
    info("=" * 80)
    info("Test Completed: #{test_name} - Status: #{status}")
    info("=" * 80)
  end

  def self.log_step(step_description)
    info("Step: #{step_description}")
  end

  def self.log_api_request(method, url, body = nil)
    info("API Request: #{method.upcase} #{url}")
    debug("Request Body: #{body}") if body
  end

  def self.log_api_response(status, body)
    info("API Response: Status #{status}")
    debug("Response Body: #{body}")
  end
end
