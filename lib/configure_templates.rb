require 'yaml'
require 'fileutils'

BASEDIR = File.dirname(__FILE__)
Dir.chdir(File.join(BASEDIR, ".."))

RESOURCES_YAML_FILE=File.join("config-templates", "resources.yaml")
CONFIG_DIR=File.join("tmp", "config")
RESOURCES_YAML_OUTPUT_FILE=File.join(CONFIG_DIR, "resources.yaml")

REQUIRED_ENV = %w(
  CLOUDSDK_CORE_PROJECT
  WEECHAT_PASSWORD
)

def require_env(var)
  unless ENV[var] && !ENV[var].empty?
    fail "Error: #{var} not set"
  end
end

REQUIRED_ENV.each do |var|
  require_env(var)
  Object.const_set var, ENV[var]
end

WEECHAT_DOCKER_IMAGE="gcr.io/#{CLOUDSDK_CORE_PROJECT}/weechat"
OPENSSH_SERVER_DOCKER_IMAGE="gcr.io/#{CLOUDSDK_CORE_PROJECT}/openssh-server"

FileUtils.mkdir_p(CONFIG_DIR)

WEECHAT_STARTUP_COMMANDS = <<-WEECHAT_COMMANDS.gsub("\n", "")
/set relay.network.password "#{WEECHAT_PASSWORD}";
/set logger.file.mask "$plugin.$name.log";
/relay add weechat 8001;
WEECHAT_COMMANDS

resources = YAML::load_stream(File.read(RESOURCES_YAML_FILE))

weechat_pod = resources.detect do |resource|
  resource['metadata']['name'] == 'weechat'
end
weechat_container = weechat_pod['spec']['containers'].detect do |container|
  container['name'] == 'weechat'
end
weechat_container['env'] ||= []
weechat_container['env'] << {
  'name' => 'WEECHAT_PASSWORD',
  'value' => WEECHAT_PASSWORD
}
weechat_container['image'] = WEECHAT_DOCKER_IMAGE
weechat_container['args'] ||= []
weechat_container['args'].concat(['-r', WEECHAT_STARTUP_COMMANDS])
weechat_container = weechat_pod['spec']['containers'].detect do |container|
  container['name'] == 'weechat'
end
ssh_relay_container = weechat_pod['spec']['containers'].detect do |container|
  container['name'] == 'ssh-relay'
end
ssh_relay_container['image'] = OPENSSH_SERVER_DOCKER_IMAGE
ssh_relay_container['env'] ||= []
ssh_relay_container['env'] << {
  'name' => 'AUTHORIZED_KEYS',
  'value' => ENV['AUTHORIZED_KEYS']
}

File.write(RESOURCES_YAML_OUTPUT_FILE, YAML.dump_stream(*resources))
