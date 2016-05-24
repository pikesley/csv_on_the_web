module CsvOnTheWeb
  class App < Sinatra::Base
    set :public_folder, 'public'
    set :views, 'views'

    helpers Sinatra::LinkHeader
  end
end
