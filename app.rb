require 'sinatra'
require 'yaml'
require 'json'

config = YAML.load_file('config.yml')

get '/update/:channel/:version' do |channel, version|
  parameters_empty = channel.empty? || version.empty? || config['updates'][channel].empty?
  if parameters_empty || Gem::Version.new(version) >= Gem::Version.new(config['updates'][channel]['version'])
    status 204
    ''
  else
    release = config['updates'][channel]
    content_type :json
    {
      url: "#{config['environment']['base_path']}/#{channel}/#{release['version']}.zip',
      name: release['version'],
      notes: release['notes'],
      pub_date: release['pub_date']
    }.to_json
  end
end
