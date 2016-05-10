require 'sinatra'
require 'sinatra/flash'
require './lib/donger_rest'

use Rack::Session::Cookie, :expire_after => 10
set :show_exceptions, false

get '/' do
  session[:message] = 'Hello World!'
  redirect to('/welcome')
end

get '/oops' do
  erb :oops
end

$API_KEY = ENV['RIOT_API_KEY']

get '/welcome' do
  erb :summoner_form
end

post '/summonerform/' do
  summonername = params[:summonername]
  region = params[:region]


  if (summonername.nil? || summonername.empty?)
    flash[:error] = "No summoner name entered"
    redirect '/'
  elsif(region != "NA1")
    flash[:error] = "Sorry, we only support NA at this time"
    redirect '/'
  else
    erb :index, :locals => {'summonername' => summonername, 'region' => region,}
  end

end

error do
  erb :oops
end

not_found do
  erb :oops
end
