# rubocop:disable RSpec/ExampleLength
require 'spec_helper'

describe App do
  include Rack::Test::Methods

  let(:app) { described_class.new }

  it 'has working golden path' do
    # initialze game
    post '/start', { session_id: 123 }.to_json
    expect(last_response).to be_ok

    # guess 1 (correctly)
    post '/guess', { session_id: 123, value: 11 }.to_json
    expect(last_response).to be_ok

    # guess 2 (correctly)
    post '/guess', { session_id: 123, value: 222 }.to_json
    expect(last_response).to be_ok

    # guess 3 (correctly)
    post '/guess', { session_id: 123, value: 3333 }.to_json
    expect(last_response).to be_ok
  end

  it 'works with wrong answers' do
    # initialze game
    post '/start', { session_id: 123 }.to_json
    expect(last_response).to be_ok

    # guess 1 (correctly)
    post '/guess', { session_id: 123, value: 11 }.to_json
    expect(last_response).to be_ok

    # guess 2 (in-correctly)
    post '/guess', { session_id: 123, value: 999 }.to_json
    expect(last_response.status).to eq 400

    # guess 2 (correctly)
    post '/guess', { session_id: 123, value: 222 }.to_json
    expect(last_response).to be_ok

    # guess 3 (correctly)
    post '/guess', { session_id: 123, value: 3333 }.to_json
    expect(last_response).to be_ok
  end

  it 'gets state' do
    get '/state'
    expect(last_response).to be_ok
  end
end
