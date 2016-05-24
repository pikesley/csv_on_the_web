module CsvOnTheWeb
  HTML_HEADERS = { 'HTTP_ACCEPT' => 'text/html' }
  JSON_HEADERS = { 'HTTP_ACCEPT' => 'application/json' }
  CSV_HEADERS = { 'HTTP_ACCEPT' => 'text/csv' }

  describe App do
    it 'says hello' do
      get '/', nil, HTML_HEADERS
      expect(last_response).to be_ok
      expect(last_response.header['Content-type']).to match /text\/html/
      expect(last_response.body).to match /Hello from CsvOnTheWeb/
    end

    it 'serves JSON' do
      get '/', nil, JSON_HEADERS
      expect(last_response).to be_ok
      expect(last_response.header['Content-type']).to eq 'application/json'
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
        expect(last_response.header['Content-type']).to eq 'text/csv'
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

    context 'CSVOTW metadata' do
      it 'serves the JSON' do
        get '/data/planting', nil, { 'HTTP_ACCEPT' => 'application/csvm+json' }
        expect(last_response).to be_ok
        expect(last_response.header['Content-type']).to eq 'application/csvm+json'
        expect(JSON.parse last_response.body).to eq (
          {
            "@context" => "http://www.w3.org/ns/csvw",
            "url" => "planting.csv",
            "tableSchema" => {
              "columns" => [
                {
                  "titles" => "plot"
                },
                {
                  "titles" => "tomato"
                }
              ]
            }
          }
        )
      end
    end
  end
end
