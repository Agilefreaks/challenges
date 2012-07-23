APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), ".."))
(1..9).each do |i|
  $: << File.join(APP_ROOT, "lib/ch#{i}")
end

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
end