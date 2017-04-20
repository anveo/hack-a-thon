require 'sinatra'
require 'alexa_skills_ruby'
require 'active_support/all'
require 'csv'
require 'dotenv/load'

require 'httplog'

require_relative './game_manager'
require_relative './price_scrambler_handler'

$game_manager = GameManager.new(csv_file: 'items.csv') # rubocop:disable Style/ClassVars

class App < Sinatra::Base
  configure do
    enable :logging
  end

  before do
    begin
      @headers  = {
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
      handler.handle(request.body.read, @headers)
    rescue AlexaSkillsRuby::Error => e
      logger.error e
      logger.error e.backtrace.join("\n")
      403
    end
  end
end
