module CsvOnTheWeb
  JSON_HEADERS = { 'HTTP_ACCEPT' => 'application/json' }
  CSV_HEADERS = { 'HTTP_ACCEPT' => 'text/csv' }

  describe App do
    it 'says hello' do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to match /Hello from CsvOnTheWeb/
    end

    it 'serves JSON' do
      get '/', nil, JSON_HEADERS
      expect(last_response).to be_ok
      expect(JSON.parse last_response.body).to eq (
        {
          'app' => 'CsvOnTheWeb'
        }
      )
    end

    context 'CSV' do
      it 'serves planting CSV' do
        get '/data/planting', nil, CSV_HEADERS
        expect(last_response).to be_ok
        expect(last_response.body).to eq (
        """plot,tomato
0,ildi
1,black cherry
2,ildi
3,unknown
4,golden sunrise
5,golden sunrise
6,sungold
7,unknown
8,orange fizz
"""
        )
      end

      it 'serves the tomato CSV' do
        get '/data/tomatoes', nil, CSV_HEADERS
        expect(last_response).to be_ok
        expect(last_response.body).to eq (
        """common name,botanical name,type
ildi,Solanum lycopersicum,cordon
black cherry,Lycopersicon esculentum,cordon
golden sunrise,Solanum lycopersicum,cordon
sungold,Lycopersicon esculentum,cordon
orange fizz,Lycopersicon esculentum,cordon
"""
        )
      end
    end
  end
end
