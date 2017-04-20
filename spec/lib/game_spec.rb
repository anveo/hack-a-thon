require 'spec_helper'

describe Game do
  let(:session_id) { 123 }
  let(:test_file) { 'test.csv' }
  let(:session_id) { 123 }
  let(:game_manager) { GameManager.new(csv_file: test_file) }
  let(:questions) { game_manager.questions }
  subject(:game) { described_class.new(session_id: session_id, questions: questions) }

  it 'sets session_id, level, and updated_at' do
    expect(game.session_id).to eq(session_id)
    expect(game.level).to eq(1)
    expect(game.updated_at).to be_within(10.seconds).of(Time.now)
  end

  it 'reports a game is lost' do
    wrong_answer = 0
    game.answer_current_question_with(wrong_answer)
    game.answer_current_question_with(wrong_answer)

    expect(game.lost?).to be(true)
    expect(game.won?).to be(false)
    expect(game.over?).to be(true)
  end

  it 'reports a game is won' do
    some_answer = 42
    allow_any_instance_of(Question).to receive(:correct_answer?).with(some_answer).and_return(true)

    questions.each do |_q|
      game.answer_current_question_with(some_answer)
    end

    expect(game.won?).to be(true)
    expect(game.lost?).to be(false)
    expect(game.over?).to be(true)
  end

  it 'reports a game is over' do
    wrong_answer = 0
    game.answer_current_question_with(wrong_answer)

    expect(game.over?).to be(false)
    expect(game.won?).to be(false)
    expect(game.lost?).to be(false)
  end

  it 'returns the correct current_question' do
    allow_any_instance_of(Question).to receive(:answer).and_return(11)
    allow_any_instance_of(Question).to receive(:item).and_return('Foo Bar')

    expect(game.current_question).to include('Foo Bar')
    expect(game.current_question).to include('1, 1')
  end
end
