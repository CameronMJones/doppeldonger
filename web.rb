require 'sinatra'
require 'haml'

use Rack::Session::Cookie, :expire_after => 10

get '/' do
  session[:message] = 'Hello World!'
  redirect to('/welcome')
end

$API_KEY = ENV['RIOT_API_KEY']

get '/welcome' do
  erb :summoner_form
end

post '/summonerform/' do
  summonername = params[:summonername] || ""
  region = params[:region] || ""

  erb :index, :locals => {'summonername' => summonername, 'region' => region,}
end
