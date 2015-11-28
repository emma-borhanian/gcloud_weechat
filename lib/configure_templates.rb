require 'yaml'
require 'fileutils'

BASEDIR = File.dirname(__FILE__)
Dir.chdir(File.join(BASEDIR, ".."))

CONFIG_TEMPLATES_DIR="config-templates"
CONFIG_DIR=File.join("tmp", "config")

REQUIRED_ENV = %w(
  CLOUDSDK_CORE_PROJECT
  WEECHAT_PASSWORD
)
REQUIRED_ENV.each do |var|
  unless ENV[var] && !ENV[var].empty?
    fail "Error: #{var} not set"
  end
  Object.const_set var, ENV[var]
end

WEECHAT_DOCKER_IMAGE="gcr.io/#{CLOUDSDK_CORE_PROJECT}/weechat"

FileUtils.mkdir_p(CONFIG_DIR)

Dir.foreach(CONFIG_TEMPLATES_DIR) do |config_filename|
  next unless config_filename.end_with? '.yaml'

  template_filepath = File.join(CONFIG_TEMPLATES_DIR, config_filename)
  content = YAML.load_file(template_filepath)

  case config_filename
  when 'weechat-pod.yaml'
    content['spec']['containers'].first['env'] << {
      'name' => 'WEECHAT_PASSWORD',
      'value' => WEECHAT_PASSWORD
    }
    content['spec']['containers'].first['image'] = WEECHAT_DOCKER_IMAGE
  end

  config_filepath = File.join(CONFIG_DIR, config_filename)
  File.write(config_filepath, YAML.dump(content))
end
