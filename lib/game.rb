class Game
  attr_accessor :session_id, :level, :updated_at

  def initialize(session_id:, questions:)
    @session_id = session_id
    @questions = questions
    @level = 1
    @updated_at = Time.now
    @wrong_guesses = 0
  end

  def lost?
    @wrong_guesses > 1
  end

  def won?
    @level > @questions.count
  end

  def over?
    won? || lost?
  end

  def answer_current_question_with(answer)
    if question_correctness = question.correct_answer?(answer)
      @level += 1
      @wrong_guesses = 0
    else
      @wrong_guesses += 1
    end
    @updated_at = Time.now
    question_correctness
  end

  def current_question
    item = question.item
    digits = question.answer.to_s.chars.join(', ')
    "The item is #{item}. The digits are #{digits}"
  end

  private

  def question
    @questions[@level]
  end
end
