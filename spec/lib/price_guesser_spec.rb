require 'spec_helper'

describe PriceGuesser do
  subject(:guesser) { described_class.new(csv_file: 'test.csv') }

  it 'works' do

    guesser.start(session_id: 123)
    expect(guesser.guess(session_id: 123, value: 11)).to be_truthy
  end
end
