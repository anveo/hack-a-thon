class PriceScramblerHandler < AlexaSkillsRuby::Handler
  on_session_start do
    logger.info 'Starting Session!'
  end

  on_launch do
    logger.info 'Launch!'
    session_id = session.session_id

    $game.start(session_id: session_id)
    speech_text = $game.current_question(session_id: session_id)

    response.set_reprompt_speech_text('Human you are slow! Answer me!')
    response.should_end_session = false
    response.set_output_speech_text(speech_text)
  end

  on_intent('AnswerIntent') do
    slots      = request.intent.slots
    session_id = session.session_id
    val        = slots['Answer'].to_i
    correct    = $game.guess(session_id: session_id, value: val)
    speech_text = ''

    if correct
      speech_text << 'Correct! '
      speech_text << $game.current_question(session_id: session_id)
    else
      speech_text << 'Stupid human! You are wrong. Try again.'
    end

    response.set_reprompt_speech_text('Human you are slow! Answer me!')
    response.should_end_session = false
    response.set_output_speech_text(speech_text)
  end

  on_intent('RepeatIntent') do
    session_id = session.session_id
    q = $game.current_question(session_id: session_id)
    response.set_output_speech_text(q)
  end
end
