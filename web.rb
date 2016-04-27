require 'sinatra'

get '/' do
  "Hello"
end

get '/hello/' do
  erb :hello_form
end

post '/hello/' do
  apikey = params[:apikey] || "Hi There"

  erb :index, :locals => {'apikey' => apikey,}
end
