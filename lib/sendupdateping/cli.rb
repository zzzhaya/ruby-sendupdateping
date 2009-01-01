require 'optparse'
require 'sendupdateping'
require 'yaml'

module Sendupdateping
  class CLI
    def self.execute(stdout, arguments=[])

      options = {
        :config     => nil
      }
      mandatory_options = %w( config )

      parser = OptionParser.new do |opts|
        opts.banner = <<-BANNER.gsub(/^          /,'')
          Sending ping

          Usage: #{File.basename($0)} [options]

          Options are:
        BANNER
        opts.separator ""
        opts.on("-c", "--config=YAML", String,
                "read YAML as a config file"
                ) { |arg| options[:config] = YAML.load_file( arg ) }
        opts.on("-h", "--help",
                "Show this help message.") { stdout.puts opts; exit }
        opts.parse!(arguments)

        if mandatory_options && mandatory_options.find { |option| options[option.to_sym].nil? }
          stdout.puts opts; exit
        end
      end

      # do stuff
      cli = Sendupdateping.new(options[:config])
      cli.ping
    end
  end
end
