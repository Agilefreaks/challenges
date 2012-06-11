APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), ".."))
$: << File.join(APP_ROOT, "lib/ch1")
$: << File.join(APP_ROOT, "lib/ch2")
$: << File.join(APP_ROOT, "lib/ch3")

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
end