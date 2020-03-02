# frozen_string_literal: true

require 'logger'

module Solargraph
  module Logging
    DEFAULT_LOG_LEVEL = Logger::DEBUG

    LOG_LEVELS = {
      'warn' => Logger::WARN,
      'info' => Logger::INFO,
      'debug' => Logger::DEBUG
    }

    module MakeFileFlushOnWrite
      def write(*)
        result = super
        flush
        result
      end
    end

    nigels_file = File.open('/home/nigel/DEBUG.LOG', File::WRONLY | File::APPEND)
    nigels_file.singleton_class.prepend MakeFileFlushOnWrite

    @@logger = Logger.new(nigels_file, level: DEFAULT_LOG_LEVEL)
    @@logger.formatter = proc do |severity, datetime, progname, msg|
      "[#{severity}] #{msg}\n"
    end

    module_function

    # @return [Logger]
    def logger
      @@logger
    end
  end
end
