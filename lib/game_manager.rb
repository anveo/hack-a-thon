require_relative './game'
require_relative './question'

class GameManager
  attr_reader :questions, :games

  def initialize(csv_file: 'items.csv')
    @questions = []
    @games = []

    filename = File.expand_path("../../data/#{csv_file}", __FILE__)
    csv = CSV.readlines(filename)
    csv.delete_at(0)
    csv.each_index do |index|
      row = csv[index]
      @questions << Question.new(
        level: index + 1,
        item: row[1],
        answer: row[2].to_i
      )
    end
  end

  def find_or_create_game_by_session_id(session_id)
    # cleanup duplicate game
    @games.delete_if { |g| g[:session_id] == session_id }

    # cleanup old sessions
    @games.delete_if { |g| g[:updated_at] <  Time.now - 1.hour.ago }

    if current_game = @games.find { |g| g[:session_id] == session_id }
      return current_game
    else
      Game.new(session_id: session_id, questions: @questions).tap do |new_game|
        @games << new_game
      end
    end
  end
end
