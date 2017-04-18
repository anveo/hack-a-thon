require 'sinatra'
require 'active_support/all'

require_relative './price_guesser'

class App < Sinatra::Base
  configure do
    @@guesser = PriceGuesser.new(csv_file: 'test.csv') # rubocop:disable Style/ClassVars
  end

  before do
    begin
      request.body.rewind
      @request_payload = JSON.parse request.body.read
      @session_id      = @request_payload['session_id']
    rescue JSON::ParserError
      @request_payload = {}
      @session_id      = nil
    end
  end

  post '/start' do
    session_id = @request_payload['session_id']
    @@guesser.start(session_id: session_id)
    200
  end

  post '/guess' do
    session_id = @request_payload['session_id']
    val        = @request_payload['value']
    res        = @@guesser.guess(session_id: session_id, value: val)

    q = @@guesser.current_question(session_id: session_id)
    puts q

    status res ? 200 : 400
  end

  get '/state' do
    @@guesser.to_json
  end
end
