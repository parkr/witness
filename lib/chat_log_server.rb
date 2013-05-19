$:.unshift(File.dirname(__FILE__))

require 'safe_yaml'
require 'active_record'
require 'time'

module ChatLogServer
  ROOT = File.expand_path("../../", __FILE__)

  def self.load_config_file(filename)
    path = File.join(ROOT, 'config', filename)
    if File.file?(path)
      return YAML.safe_load_file(path)
    end
    Hash.new
  end

  def self.load_configs
    base = Hash.new
    base = base.merge(load_config_file('log-server.yml'))
    base = base.merge(load_config_file('auth.yml'))
    base = base.merge(load_config_file('database.yml'))
  end

  def self.config(key)
    @@configs ||= load_configs
    @@configs.fetch(key)
  end

  def self.root
    File.expand_path("../../", __FILE__)
  end
end

require 'chat_log_server/api'
require 'chat_log_server/message'
require 'chat_log_server/helpers/auth'
require 'chat_log_server/helpers/paths'
require 'chat_log_server/helpers/urls'
