require 'csv'

class PriceGuesser
  def initialize(csv_file: 'items.csv')
    @items = []
    @games = []

    filename = File.expand_path("../../data/#{csv_file}", __FILE__)
    CSV.foreach(filename) do |row|
      @items << {
        level: row[0].to_i,
        item: row[1],
        answer: row[2].to_i
      }
    end
  end

  def start(session_id:)
    # cleanup duplicate game
    @games.delete_if { |g| g[:session_id] == session_id }

    # cleanup old sessions
    @games.delete_if { |g| g[:updated_at] <  Time.now - 1.hour.ago }

    @games << default_state.merge(session_id: session_id, level: 1)
  end

  def guess(session_id: nil, value:)
    game = game_by_id(session_id)

    return false unless game
    return false unless @items.any? { |i| i[:level] == game[:level] && i[:answer] == value.to_i }

    next_level(session_id: session_id)
  end

  def next_level(session_id:)
    game = game_by_id(session_id)
    game.merge!(level: game[:level] + 1)
  end

  def current_question(session_id:)
    game = game_by_id(session_id)
    return false unless game
    item = @items.find { |i| i[:level] == game[:level] }
    return false unless item

    "The item is #{item[:item]}. The digits are #{item[:answer].to_s.chars.join(' ')}"
  end

  private

  def game_by_id(id)
    @games.find { |g| g[:session_id] == id }
  end

  def default_state
    {
      session_id: nil,
      level: nil,
      status: 'inprogress',
      item_id: nil,
      updated_at: Time.now
    }
  end
end
