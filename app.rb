require 'sinatra'
require 'yaml'
require 'json'
require 'time'

config = YAML.load_file('config.yml')

get '/update/:channel/:version' do |channel, version|
  parameters_empty = channel.empty? || version.empty? || !config['updates'][channel] || config['updates'][channel].empty?
  begin
    no_need_for_update = Gem::Version.new(version) >= Gem::Version.new(config['updates'][channel]['version'])
  rescue
    no_need_for_update = true
  end
  if parameters_empty || no_need_for_update
    status 204
    ''
  else
    release = config['updates'][channel]
    content_type :json
    {
      url: "#{config['environment']['base_path']}/#{channel}/#{release['version']}.zip",
      name: release['version'],
      notes: release['notes'],
      pub_date: Time.parse(release['pub_date']).iso8601
    }.to_json
  end
end
