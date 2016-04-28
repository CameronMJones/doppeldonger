require 'sinatra'

$API_KEY = ENV['RIOT_API_KEY']

get '/' do
  erb :summoner_form
end

post '/summonerform/' do
  summonername = params[:summonername] || ""
  region = params[:region] || ""

  erb :index, :locals => {'summonername' => summonername, 'region' => region,}
end
