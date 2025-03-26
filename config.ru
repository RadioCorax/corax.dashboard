# frozen_string_literal: true

require 'dotenv/load'
require 'dashing'

configure do
  set :auth_token, ENV.fetch('AUTH_TOKEN')
  set :default_dashboard, 'corax'

  # See http://www.sinatrarb.com/intro.html > Available Template Languages on
  # how to add additional template languages.
  set :template_languages, %i[html erb]
  set :show_exceptions, true
  set :icecast_url, ENV.fetch('ICECAST_URL')
  set :icecast_server_name, ENV.fetch('ICECAST_SERVER_NAME')
  set :mairlist_url, ENV.fetch('MAIRLIST_URL')
  set :mairlist_username, ENV.fetch('MAIRLIST_USERNAME')
  set :mairlist_password, ENV.fetch('MAIRLIST_PASSWORD')
  set :mairlist_playlist_day, ENV.fetch('MAIRLIST_PLAYLIST_DAY')
  set :mairlist_playlist_night, ENV.fetch('MAIRLIST_PLAYLIST_NIGHT')

  helpers do
    def protected!
      # Put any authentication code you want in here.
      # This method is run before accessing any resource.
    end
  end
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application
