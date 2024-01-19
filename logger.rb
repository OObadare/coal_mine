require 'json'

class Logger
    attr_reader :path
    def initialize
        @path = "log.json"
        ensure_log_creation
    end

    def add_log_entry(entry)
        logs = read_logs
        logs << entry
        write_logs(logs)
    end

  private

  # Read the current logs from the file
    def read_logs
        if File.exist?(path)
        JSON.parse(File.read(path))
        else
        []
        end
    rescue JSON::ParserError
        []
    end

  # Write the updated logs to the file
    def write_logs(logs)
        File.write(path, JSON.pretty_generate(logs))
    end

    def ensure_log_creation
        unless File.exist?(path)
            File.write(path, JSON.pretty_generate([]))
        end
    end
end
