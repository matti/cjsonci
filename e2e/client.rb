require_relative "../lib/cjsonci"

c = CJSONCI::Client.new "ruby e2e/servant.rb"
c.eval "a = 1"
c.eval "b = a + 1"

value = c.eval "b"
puts value["result"]
raise "err" unless value["result"] == 2
