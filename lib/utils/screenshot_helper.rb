require 'fileutils'

class ScreenshotHelper
  SCREENSHOT_DIR = './screenshots'.freeze

  def self.setup_screenshot_directory
    FileUtils.mkdir_p(SCREENSHOT_DIR) unless Dir.exist?(SCREENSHOT_DIR)
  end

  def self.take_screenshot(driver, name = nil)
    setup_screenshot_directory
    
    timestamp = Time.now.strftime('%Y%m%d_%H%M%S')
    filename = name ? "#{name}_#{timestamp}.png" : "screenshot_#{timestamp}.png"
    filepath = File.join(SCREENSHOT_DIR, filename)
    
    driver.save_screenshot(filepath)
    puts "Screenshot saved: #{filepath}"
    filepath
  rescue StandardError => e
    puts "Error taking screenshot: #{e.message}"
    nil
  end

  def self.take_screenshot_on_failure(driver, scenario_name)
    sanitized_name = scenario_name.gsub(/[^0-9A-Za-z.\-]/, '_')
    take_screenshot(driver, "FAILED_#{sanitized_name}")
  end

  def self.clear_old_screenshots(days = 7)
    setup_screenshot_directory
    
    cutoff_time = Time.now - (days * 24 * 60 * 60)
    
    Dir.glob(File.join(SCREENSHOT_DIR, '*.png')).each do |file|
      File.delete(file) if File.mtime(file) < cutoff_time
    end
  rescue StandardError => e
    puts "Error clearing old screenshots: #{e.message}"
  end

  def self.embed_screenshot_in_report(driver, scenario)
    screenshot = take_screenshot(driver, scenario.name)
    return unless screenshot && File.exist?(screenshot)

    image_data = File.binread(screenshot)
    scenario.attach(image_data, 'image/png')
  rescue StandardError => e
    puts "Error embedding screenshot: #{e.message}"
  end
end
