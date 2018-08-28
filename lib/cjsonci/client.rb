require "json"
require "open3"

module CJSONCI
  class Client
    def initialize(cmd)
      @stdin, @stdout, @stderr, @wait_thr = Open3.popen3(cmd)
      @queue = Queue.new

      Thread.new do
        @stdout.each_line do |line|
          @queue.push JSON.parse(line)
        end
      end
    end

    def eval(code)
      input = {
        eval: code,
      }
      @stdin.puts input.to_json
      result = nil
      begin
        puts "BLO"
        result = @queue.pop
        puts "COK"
      rescue Exception => ex
        @stderr.each_line do |line|
          puts line
        end
        exit 1
      end

      puts "GOT"
      result
    end

    def close
      @stdin.close
    end
  end
end
