require "json"
require "open3"

module CJSONCI
  class Client
    def initialize(cmd)
      @stdin, @stdout, @stderr, @wait_thr = Open3.popen3(cmd)
      @queue = Queue.new

      # consider something like https://github.com/kontena/kontena/blob/edb1d6c40e1ceb1b5aae88501d35cda525b64339/cli/lib/kontena/cli/helpers/exec_helper.rb#L38-L51
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
        result = @queue.pop
      rescue Exception => ex
        @stderr.each_line do |line|
          puts line
        end
        exit 1
      end

      result
    end

    def close
      @stdin.close
    end
  end
end
