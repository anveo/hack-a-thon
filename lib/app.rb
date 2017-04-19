require 'sinatra'
require 'alexa_skills_ruby'
require 'active_support/all'
require 'csv'
require 'dotenv/load'

require 'httplog'

require_relative './price_guesser'
require_relative './price_scrambler_handler'

$game = PriceGuesser.new(csv_file: 'items.csv') # rubocop:disable Style/ClassVars

class App < Sinatra::Base
  configure do
    enable :logging
    # @@guesser = PriceGuesser.new(csv_file: 'test.csv') # rubocop:disable Style/ClassVars
  end

  before do
    begin
      # require 'pry'
      # binding.pry
      # request.body.rewind
      # @request_payload = JSON.parse request.body.read
      # @session_id      = @request_payload['session_id']
      @headers         = {
        'Signature'             => request.env['HTTP_SIGNATURE'],
        'SignatureCertChainUrl' => request.env['HTTP_SIGNATURECERTCHAINURL']
      }
    rescue MultiJson::ParseError, JSON::ParserError
      @request_payload = {}
      @session_id      = nil
    end
  end

  post '/' do
    content_type :json

    handler = PriceScramblerHandler.new(
      application_id: ENV['APPLICATION_ID'],
      logger: logger,
      skip_signature_validation: true
    )

    begin
      # logger.info request.body.read
      handler.handle(request.body.read, @headers)
    rescue AlexaSkillsRuby::Error => e
      logger.error e
      logger.error e.backtrace.join("\n")
      403
    end
  end

  post '/start' do
    session_id = @request_payload['session_id']
    $game.start(session_id: session_id)
    200
  end

  post '/guess' do
    session_id = @request_payload['session_id']
    val        = @request_payload['value']
    res        = $game.guess(session_id: session_id, value: val)

    q = $game.current_question(session_id: session_id)
    puts q

    status res ? 200 : 400
  end

  get '/state' do
    $game.to_json
  end
end
