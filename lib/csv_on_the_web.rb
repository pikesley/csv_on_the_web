require 'sinatra/base'
require 'tilt/erubis'
require 'json'
require 'csv'

require_relative 'csv_on_the_web/racks'
require_relative 'csv_on_the_web/helpers'

module CsvOnTheWeb
  class App < Sinatra::Base
    helpers do
      include CsvOnTheWeb::Helpers
    end

    get '/' do
      headers 'Vary' => 'Accept'

      respond_to do |wants|
        wants.html do
          @content = '<h1>Hello from CsvOnTheWeb</h1>'
          @title = 'CsvOnTheWeb'
          erb :index, layout: :default
        end

        wants.json do
          {
            app: 'CsvOnTheWeb'
          }.to_json
        end

        wants.csv do
          [
            'Hello',
            'from',
            'CSV'
          ].to_csv
        end
      end
    end

    get '/data/:dataset' do
      respond_to do |wants|
        wants.csv do
          File.read "data/csv/#{params[:dataset]}.csv"
        end
      end
    end

    # start the server if ruby file executed directly
    run! if app_file == $0
  end
end
