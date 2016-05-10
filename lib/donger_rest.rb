require_relative 'donger_string'
require 'rest-client'
require 'json'

class DongerRest
	KEY = ENV["RIOT_API_KEY"]

	def self.get_champion_info()
		call("https://global.api.pvp.net/api/lol/static-data/na/v1.2/champion?champData=all&api_key=#{KEY}")
	end

	def self.get_summoners(names)
		sanitized_names = names.map{|name| DongerString.sanitize(name)}
		encoded_names = sanitized_names.map{|name| DongerString.encode(name)}
		delimited_names = sanitized_names.join(',')
		call("https://na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/#{delimited_names}?api_key=#{KEY}")
	end

	def self.get_champion_name(id)
		call("https://global.api.pvp.net/api/lol/static-data/na/v1.2/champion/#{id}?champData=info&api_key=#{KEY}")["name"]
	end

	def self.get_masteries(id)
		call("https://na.api.pvp.net/championmastery/location/na1/player/#{id}/topchampions?api_key=#{KEY}")
	end

	def self.get_leagues(ids)
		delimited_ids = ids.join(',')
		call("https://na.api.pvp.net/api/lol/na/v2.5/league/by-summoner/#{delimited_ids}?api_key=#{KEY}")
	end

	def self.get_games()
		call("https://na.api.pvp.net/observer-mode/rest/featured?api_key=#{KEY}")
	end

	def self.call(url)
		sleep 0.01
		request = {:url => url, :method => :get, :verify_ssl => false}
		response = RestClient::Request.execute(request)
		JSON.parse(response)
	end
end
