require 'freshdesk_api'

begin
  require 'byebug'
rescue LoadError
end

def client
  credentials = File.join(File.dirname(__FILE__), '..', 'fixtures', 'credentials.yml')
  @client ||= begin
    client = FreshdeskAPI::Client.new do |config|
      if File.exists?(credentials)
        data = YAML.load(File.read(credentials))
        config.username = data["username"]
        config.password = data["password"]
        config.url = data["url"]
      else
        STDERR.puts "add your credentials to spec/fixtures/credentials.yml (see: spec/fixtures/credentials.yml.example)"
      end
    end

    client
  end
end
