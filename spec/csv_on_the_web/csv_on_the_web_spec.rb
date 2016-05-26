module CsvOnTheWeb
  HTML_HEADERS = { 'HTTP_ACCEPT' => 'text/html' }
  JSON_HEADERS = { 'HTTP_ACCEPT' => 'application/json' }
  CSV_HEADERS = { 'HTTP_ACCEPT' => 'text/csv' }

  describe App do
    it 'says hello' do
      get '/', nil, HTML_HEADERS
      expect(last_response).to be_ok
      expect(last_response.header['Content-type']).to match /text\/html/
      expect(last_response.body).to match /How does CSV On The Web work\?/
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

      it 'gets the CSV via extension' do
        get '/data/tomatoes.csv'
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
      it 'serves the metadata JSON' do
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

      it 'serves the metadata JSON at the expected URL' do
        get '/data/tomatoes.csv-metadata.json'
        expect(last_response).to be_ok
        expect(last_response.header['Content-type']).to eq 'application/csvm+json'
        expect(JSON.parse last_response.body).to include (
          {
            "@context" => "http://www.w3.org/ns/csvw",
            "schema:name" => "Tomato types",
            "schema:description" => "Data about tomato types",
            "schema:creator" => {
              "schema:name" => "Sam",
              "schema:url" => "http://sam.pikesley.org",
              "@type" => "schema:Person"
            }
          }
        )
      end

      it 'gets the metadata headers' do
        get '/data/tomatoes.csv'
        expect(last_response).to be_ok
        expect(last_response.header['Link']).to eq (
          "<example.org/data/tomatoes>; rel=\"describedby\"; type=\"application/csvm+json\""
        )
      end
    end
  end
end
