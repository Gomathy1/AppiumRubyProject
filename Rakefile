require 'cucumber/rake/task'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

desc 'Run all tests'
task default: [:rubocop, :unit_tests, :cucumber]

desc 'Run RuboCop'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = ['lib/**/*.rb', 'features/**/*.rb', 'spec/**/*.rb']
  task.fail_on_error = false
end

desc 'Run RSpec unit tests'
RSpec::Core::RakeTask.new(:unit_tests) do |task|
  task.pattern = 'spec/unit/**/*_spec.rb'
  task.rspec_opts = '--format documentation --color'
end

desc 'Run RSpec integration tests'
RSpec::Core::RakeTask.new(:integration_tests) do |task|
  task.pattern = 'spec/integration/**/*_spec.rb'
  task.rspec_opts = '--format documentation --color'
end

desc 'Run all RSpec tests'
RSpec::Core::RakeTask.new(:spec) do |task|
  task.pattern = 'spec/**/*_spec.rb'
  task.rspec_opts = '--format documentation --color'
end

desc 'Run Cucumber smoke tests'
Cucumber::Rake::Task.new(:smoke) do |task|
  task.cucumber_opts = '--tags @smoke --format pretty'
end

desc 'Run Cucumber UI tests'
Cucumber::Rake::Task.new(:ui_tests) do |task|
  task.cucumber_opts = '--tags @ui --format pretty'
end

desc 'Run Cucumber API tests'
Cucumber::Rake::Task.new(:api_tests) do |task|
  task.cucumber_opts = '--tags @api --format pretty'
end

desc 'Run Cucumber security tests'
Cucumber::Rake::Task.new(:security_tests) do |task|
  task.cucumber_opts = '--tags @security --format pretty'
end

desc 'Run all Cucumber tests'
Cucumber::Rake::Task.new(:cucumber) do |task|
  task.cucumber_opts = '--format pretty --format html --out reports/cucumber_report.html'
end

desc 'Run tests in parallel'
task :parallel do
  sh 'parallel_cucumber features/ -n 2'
end

desc 'Generate Allure report'
task :allure_report do
  sh 'allure serve allure-results'
end

desc 'Clean test artifacts'
task :clean do
  sh 'rm -rf reports/ allure-results/ coverage/ screenshots/ logs/'
  puts 'Test artifacts cleaned!'
end

desc 'Setup project'
task :setup do
  puts 'Installing dependencies...'
  sh 'bundle install'
  puts 'Creating necessary directories...'
  sh 'mkdir -p reports screenshots logs apps/android apps/ios'
  puts 'Setup complete!'
end

desc 'Run full test suite'
task :full_suite do
  Rake::Task[:clean].invoke
  Rake::Task[:rubocop].invoke
  Rake::Task[:spec].invoke
  Rake::Task[:cucumber].invoke
  puts 'Full test suite completed!'
end
