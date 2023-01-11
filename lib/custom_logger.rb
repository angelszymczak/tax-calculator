# frozen_string_literal: true

require 'logger'

class CustomLogger < Logger
  def format_message(severity, timestamp, progname, msg)
    "#{severity.ljust(5)} [#{timestamp.strftime('%Y-%m-%d %H:%M:%S')}] #{progname} --\n#{msg}\n\n"
  end
end
