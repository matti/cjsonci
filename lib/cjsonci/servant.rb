require "json"

module CJSONCI
  module Servant
    def self.run!
      loop do
        obj = read_input
        result = eval_input(obj)
        puts format_message(result).to_json
      end
    end

    private

    def self.read_input
      input = ""
      obj = nil
      loop do
        line = STDIN.gets
        exit 0 unless line
        input << line

        begin
          obj = JSON.parse(input)
        rescue
        end

        break if obj
      end

      obj
    end

    def self.eval_input(obj)
      code = obj["eval"]
      eval_result = nil
      begin
        eval_result = TOPLEVEL_BINDING.eval code.to_s
      rescue Exception => ex
        eval_result = ex
      end

      case eval_result.class.name
      when "SignalException"
        case eval_result.message
        when "SIGTERM"
          exit 0
        end
      when "SystemExit"
        exit 0
      end

      eval_result
    end

    def self.format_message(result)
      if result.is_a? Exception
        {
          type: "error",
          class: result.class,
          message: result,
        }
      else
        {
          type: "ok",
          result: result,
        }
      end
    end
  end
end
