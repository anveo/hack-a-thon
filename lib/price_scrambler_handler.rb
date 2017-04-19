require 'alexa_skills_ruby'

class PriceScramblerHandler < AlexaSkillsRuby::Handler
  on_intent('AnswerIntent') do
    slots = request.intent.slots
    response.set_output_speech_text('Hello, world')
    puts "Responded with 'Hello, world'"
  end
end
