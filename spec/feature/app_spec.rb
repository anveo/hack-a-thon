# rubocop:disable RSpec/ExampleLength
require 'spec_helper'

describe App do
  include Rack::Test::Methods

  let(:app) { described_class.new }
  let(:request) do
    {
      session: {
        sessionId: "SessionId.0c753c81-fe51-46ab-84ec-625a1a1e3c18",
        application: {
        applicationId: "amzn1.ask.skill.b52f45b7-6e0a-42bd-96d2-d16d63157bb3"
      },
      attributes: {},
      user: {
        userId: "amzn1.ask.account.AHWQ2ICVMZQSSOMB4UP6UWNGJBVMM5UOYYK7W6BZEGRRGBTX5IW3KPXH4LDKLVWQ4WYPQBKUR6ZNYU7R43G5W5ZAZEZ6EXMZBFBHC46X6VZKT3GBLDT37JBRQV5WVALVRDXSQZ2BNZGZVE4MNQUCHDIQIOEXCMAYI2FDZCX3YORIY5X4YOT3XUM2OFNJL35IGEU4NPYRNTSSEGI"
      },
      new: true
      },
      request: {
        type: "LaunchRequest",
        requestId: "EdwRequestId.4e90d82d-5032-4bb8-bf77-293c3625f07f",
        locale: "en-US",
        timestamp: Time.now
      },
      version: "1.0"
    }.to_json
  end

  it 'has working / path' do
    post '/', request
    expect(last_response).to be_ok
  end
end
