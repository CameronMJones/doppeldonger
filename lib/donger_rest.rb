require 'rest-client'
require 'json'

class DongerRest
	KEY = ENV["API_KEY"]
	LIMIT = ENV["API_RATE_LIMIT"]

	def self.get_champions()
		url = "https://global.api.pvp.net/api/lol/static-data/na/v1.2/champion?champData=tags&api_key=#{KEY}"
		call(url)
	end

	def self.get_summoner_id(name)
		sanitized_name = name.gsub(/\s+/, "").downcase
		url = "https://na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/#{sanitized_name}?api_key=#{KEY}"
		call(url)
	end

	def self.get_masteries(id)
		url = "https://na.api.pvp.net/championmastery/location/na1/player/#{id}/topchampions?api_key=#{KEY}"
		call(url)
	end

	def self.get_games()
		url = "https://na.api.pvp.net/observer-mode/rest/featured?api_key=#{KEY}"
		call(url)
	end

	def self.call(url)
		sleep LIMIT
		request = {:url => url, :method => :get, :verify_ssl => false}
		response = RestClient::Request.execute(request)
		JSON.parse(response)
	end

end