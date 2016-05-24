require 'sinatra/base'
require 'tilt/erubis'
require 'json'
require 'csv'
require 'tilt/kramdown'

require_relative 'csv_on_the_web/racks'
require_relative 'csv_on_the_web/helpers'

module CsvOnTheWeb
  class App < Sinatra::Base
    helpers do
      include CsvOnTheWeb::Helpers
    end

    get '/' do
      headers 'Vary' => 'Accept'

      request.accept.each do |type|
        case type.to_s

        when 'text/html'
          @content = '<h1>Hello from CsvOnTheWeb</h1>'
          @title = 'CsvOnTheWeb'
          halt erb :index, layout: :default

        when 'application/json'
          headers 'Content-type' => type.to_s
          halt (
            {
              app: 'CsvOnTheWeb'
            }.to_json
          )

        when 'text/csv'
          headers 'Content-type' => type.to_s
          halt [
            'Hello',
            'from',
            'CSV'
          ].to_csv
        end
      end
    end

    get '/data/:dataset.?:format?' do
      extensions = {
        'csv' => 'text/csv'
      }
      type = request.accept.first.to_s
      if params[:format]
        type = extensions[params[:format]]
      end

      case type
        when 'text/csv'
          headers 'Content-type' => type.to_s
          halt File.read "data/csv/#{params[:dataset]}.csv"

        when 'application/csvm+json'
          headers 'Content-type' => type.to_s
          halt File.read "data/csv/#{params[:dataset]}.csv-metadata.json"
      end
    end

    # start the server if ruby file executed directly
    run! if app_file == $0
  end
end
