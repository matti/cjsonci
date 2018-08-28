require_relative "../lib/cjsonci"
$stdout.sync = true

c = CJSONCI::Client.new "ruby e2e/servant.rb"
c.eval "1"
