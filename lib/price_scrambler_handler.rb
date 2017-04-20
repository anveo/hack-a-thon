class PriceScramblerHandler < AlexaSkillsRuby::Handler
  GREETING = <<~HEREDOC
    Hello, and welcome to the Price Scrambler game! This game is similar
    to the Price Is Right in that you will be guessing the retail value
    of the items listed. The difference between Price Scrambler and The
    Price Is Right is that in this game we will give you the correct price
    but scramble the digits. Your job is to tell us the correct order of
    the digits that produce a number that is the retail value of the item.
    There are three rounds to the game and you are allowed one retry per
    round. If you fail to accurately guess the number more than once, you
    will lose the game. If you complete all three rounds, you win. Let us
    begin.
  HEREDOC

  on_session_start do
    logger.info 'Starting Session!'
  end

  on_launch do
    logger.info 'Launch!'
    response.should_end_session = false
    response.set_output_speech_text("#{GREETING} #{game.current_question}")
  end

  on_intent('AnswerIntent') do
    slots = request.intent.slots
    answer = slots['Answer'].to_i
    answer_was_correct = game.answer_current_question_with(answer)
    message_to_send = ''

    if game.over?
      if game.won?
        message_to_send << "Congratulations! You're not a complete failure. You have won the Price Scrambler game! You must be so proud."
      elsif game.lost?
        message_to_send << "You lost the Price Scrambler game. Please stop being such a stupid human."
      end
      response.should_end_session = true
    else
      if answer_was_correct
        message_to_send << "Correct! You're so talented. Proceeding to the next item. "
        message_to_send << game.current_question
      else
        message_to_send << 'Stupid human! You are wrong. Try again.'
      end
      response.should_end_session = false
    end
    response.set_reprompt_speech_text("What's taking so long? Did I stutter?")
    response.set_output_speech_text(message_to_send)
  end

  on_intent('RepeatIntent') do
    response.set_output_speech_text(game.current_question)
  end

  private

  def game
    @game ||= $game_manager.find_or_create_game_by_session_id(session.session_id)
  end
end
