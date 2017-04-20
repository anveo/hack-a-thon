class Question
  attr_accessor :level, :item, :answer
  def initialize(level:, item:, answer:)
    @level = level
    @item = item
    @answer = answer
  end

  def correct_answer?(proposed_answer)
    @answer == proposed_answer.to_i
  end
end
