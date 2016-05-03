require 'rest-client'
require 'json'

class DongerRest

	def self.get_champions()
		key = ENV["API_KEY"]
		url = "https://global.api.pvp.net/api/lol/static-data/na/v1.2/champion?champData=tags&api_key=#{key}"
		call(url)
	end

	def self.get_summoner_id(name)
		key = ENV["API_KEY"]
		sanitized_name = name.gsub(/\s+/, "").downcase
		url = "https://na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/#{sanitized_name}?api_key=#{key}"
		call(url)
	end

	def self.get_summoner_name(id)
		key = ENV["API_KEY"]
		url = "https://na.api.pvp.net/api/lol/na/v1.4/summoner/#{id}/name?api_key=#{key}"
		call(url)
	end

	def self.get_masteries(id)
		key = ENV["API_KEY"]
		url = "https://na.api.pvp.net/championmastery/location/na1/player/#{id}/topchampions?api_key=#{key}"
		call(url)
	end

	def self.call(url)
		request = {:url => url, :method => :get, :verify_ssl => false}
		response = RestClient::Request.execute(request)
		JSON.parse(response)
	end

end