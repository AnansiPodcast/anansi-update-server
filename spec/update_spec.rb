require 'spec_helper'
require 'json'

describe 'Update' do
  let(:stable_up_to_date) { '1.0.0' }
  let(:stable_out_to_date) { '0.1.0' }

  def app
    Sinatra::Application
  end

  it 'should not respond with a version up to date' do
    get "/update/stable/#{stable_up_to_date}"
    expect(last_response).to_not be_ok
    expect(last_response.status).to be 204
    expect(last_response.body).to eq ''
  end

  it 'should not respond with an invalid update channel' do
    get '/update/foo/1.0.0'
    expect(last_response).to_not be_ok
  end

  it 'should not respond with an invalid update version' do
    get '/update/stable/bar'
    expect(last_response).to_not be_ok
  end

  it 'should not respond with an invalid update version and invalid update channel' do
    get '/update/foo/bar'
    expect(last_response).to_not be_ok
  end

  it 'should respond with update data' do
    get "/update/stable/#{stable_out_to_date}"
    response = JSON.parse(last_response.body)
    expect(last_response).to be_ok
    expect(response['name']).to eq stable_up_to_date
    expect(response['url']).to include stable_up_to_date
  end
end
