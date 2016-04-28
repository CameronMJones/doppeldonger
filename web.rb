require 'sinatra'


get '/' do
end

get '/hello/' do
  erb :hello_form
end

post '/hello/' do
  summonername = params[:summonername] || "Hi There"

  erb :index, :locals => {'summonername' => summonername,}
end
