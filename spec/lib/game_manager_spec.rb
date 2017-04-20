require 'spec_helper'

describe GameManager do
  let(:test_file) { 'test.csv' }
  let(:session_id) { 123 }
  subject(:game_manager) { described_class.new(csv_file: test_file) }

  it 'loads questions from CSV' do
    csv_lines = CSV.readlines(File.new("data/#{test_file}"))
    row_count = csv_lines.count - 1
    expect(game_manager.questions.count).to eql(row_count)
  end
end
