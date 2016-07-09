require 'sinatra'
require 'yaml'
require 'json'
require 'time'

def get_channel(channel, config)
  if ENV.has_key?("#{channel.upcase}_VERSION")
    {
      'version' => ENV["#{channel.upcase}_VERSION"],
      'notes' => ENV["#{channel.upcase}_NOTES"],
      'pub_date' => ENV["#{channel.upcase}_DATE"]
    }
  elsif config['updates'][channel] && !config['updates'][channel].empty?
    config['updates'][channel]
  else
    false
  end
end

config = YAML.load_file('config.yml') unless ENV.has_key?('STABLE_VERSION')
base_path = ENV.has_key?('BASE_PATH') ? ENV['BASE_PATH'] : config['environment']['base_path']

get '/update/:channel/:version' do |channel, version|
  channel_data = get_channel(channel, config)
  parameters_empty = channel.empty? || version.empty? || !channel_data
  begin
    no_need_for_update = Gem::Version.new(version) >= Gem::Version.new(channel_data['version'])
  rescue
    no_need_for_update = true
  end
  if parameters_empty || no_need_for_update
    status 204
    ''
  else
    content_type :json
    {
      url: "#{base_path}/#{channel}/#{channel_data['version']}.zip",
      name: channel_data['version'],
      notes: channel_data['notes'],
      pub_date: Time.parse(channel_data['pub_date']).iso8601
    }.to_json
  end
end
