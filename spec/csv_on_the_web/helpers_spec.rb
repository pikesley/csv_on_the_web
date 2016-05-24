class TestHelper
  include CsvOnTheWeb::Helpers
end

module CsvOnTheWeb
  describe Helpers do
    let(:helpers) { TestHelper.new }

    it 'says hello' do
      expect(helpers.hello).to eq 'Hello'
    end
  end
end
