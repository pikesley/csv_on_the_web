require 'sinatra/base'
require 'sinatra/link_header'
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
      @content = '<h1>Hello from CsvOnTheWeb</h1>'
      @title = 'CsvOnTheWeb'
      halt erb :index, layout: :default
    end

    get '/data/:dataset.csv-metadata.json' do
      headers 'Content-type' => 'application/csvm+json'
      halt get_json
    end

    get '/data/:dataset.?:format?' do
      type = determine_type
      case type
        when 'text/csv'
          link "#{request.env['HTTP_HOST']}/data/#{params[:dataset]}",
                rel: :describedby,
                type: :'application/csvm+json'
          headers 'Content-type' => type.to_s
          halt File.read "data/csv/#{params[:dataset]}.csv"

        when 'application/csvm+json'
          headers 'Content-type' => type.to_s
          halt get_json
      end
    end

    # start the server if ruby file executed directly
    run! if app_file == $0

    def determine_type
      extensions = {
        'csv' => 'text/csv'
      }

      type = request.accept.first.to_s

      if params[:format]
        type = extensions[params[:format]]
      end

      type
    end

    def get_json
      (YAML.load_file "data/csv/metadata/#{params[:dataset]}.csv-metadata.yaml").to_json
    end
  end
end
