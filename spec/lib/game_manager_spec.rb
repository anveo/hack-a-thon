require 'spec_helper'

describe GameManager do
  let(:test_file) { 'test.csv' }
  let(:session_id) { 123 }
  subject(:game_manager) { described_class.new(csv_file: test_file) }

  it 'loads questions from CSV' do
    csv_lines = CSV.readlines(File.new("data/#{test_file}"))
    csv_question_count = csv_lines.count - 1
    expect(game_manager.questions.count).to eql(csv_question_count)
  end

  it 'creates a new game' do
    new_game = game_manager.find_or_create_game_by_session_id(session_id)

    expect(new_game.session_id).to eq(session_id)
    expect(game_manager.games.count).to eq(1)
  end

  context 'session management' do
    it 'returns existing game if it matches session_id' do
      current_game = game_manager.find_or_create_game_by_session_id(session_id)
      new_game = game_manager.find_or_create_game_by_session_id(session_id)

      expect(new_game).to equal(current_game)
    end

    it 'deletes an old game session' do
      old_game = game_manager.find_or_create_game_by_session_id(session_id)
      old_game.updated_at = 2.hours.ago
      game_manager.games = [old_game]

      new_game = game_manager.find_or_create_game_by_session_id(session_id)

      expect(new_game).to_not equal(old_game)
    end
  end
end
