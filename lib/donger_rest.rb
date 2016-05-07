require_relative 'donger_string'
require 'rest-client'
require 'json'

class DongerRest
	KEY = ENV["RIOT_API_KEY"]

	def self.get_champions()
		call("https://global.api.pvp.net/api/lol/static-data/na/v1.2/champion?champData=tags&api_key=#{KEY}")
	end

  def self.get_champion_skin_key(champion)
    champion = sanitize_name(champion)
    all_champion_skin_keys = call("https://global.api.pvp.net/api/lol/static-data/na/v1.2/champion?champData=skins&api_key=#{KEY}")
    champion_skin_key = all_champion_skin_keys["data"][champion]["key"]
  end

  def self.get_champion_skills(champion)
    champion = sanitize_name(champion)
    results = []
    all_champion_spell_information = call("https://global.api.pvp.net/api/lol/static-data/na/v1.2/champion?champData=spells&api_key=#{KEY}")
    champion_spells = all_champion_spell_information["data"][champion]["spells"]
    champion_spells.each do |spell|
      results.push({"description"=>"#{spell["name"]}: #{spell["sanitizedDescription"]}","image"=>spell["image"]["full"]})
    end

    results
  end

  def self.get_passive(champion)
    champion = sanitize_name(champion)
    all_champion_passive_information = call("https://global.api.pvp.net/api/lol/static-data/na/v1.2/champion?champData=passive&api_key=#{KEY}")
    champion_passive = all_champion_passive_information["data"][champion]
    result = {"description"=>"#{champion_passive["passive"]["name"]}: #{champion_passive["passive"]["sanitizedDescription"]}","image"=>champion_passive["passive"]["image"]["full"]}
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

  def self.sanitize_name(name)
    champ_keys = ["Thresh", "Aatrox", "Tryndamere", "Gragas", "Cassiopeia", "AurelionSol", "Ryze", "Poppy", "Sion", "Jhin", "Annie", "Nautilus", "Karma", "Lux", "Ahri", "Olaf", "Viktor", "Singed", "Garen", "Anivia", "Maokai", "Lissandra", "Morgana", "Fizz", "Evelynn", "Zed", "Heimerdinger", "Rumble", "Sona", "Mordekaiser", "KogMaw", "Katarina", "Lulu", "Ashe", "Karthus", "Alistar", "Darius", "Vayne", "Varus", "Udyr", "Leona", "Jayce", "Syndra", "Pantheon", "Riven", "Khazix", "Corki", "Caitlyn", "Azir", "Nidalee", "Kennen", "Galio", "Veigar", "Bard", "Gnar", "Malzahar", "Graves", "Vi", "Kayle", "Irelia", "LeeSin", "Illaoi", "Elise", "Volibear", "Nunu", "TwistedFate", "Jax", "Shyvana", "Kalista", "DrMundo", "TahmKench", "Diana", "Brand", "Sejuani", "Vladimir", "Zac", "RekSai", "Quinn", "Akali", "Tristana", "Hecarim", "Sivir", "Lucian", "Rengar", "Warwick", "Skarner", "Malphite", "Yasuo", "Xerath", "Teemo", "Renekton", "Nasus", "Draven", "Shaco", "Swain", "Ziggs", "Talon", "Janna", "Ekko", "Orianna", "Fiora", "FiddleSticks", "Rammus", "Chogath", "Leblanc", "Zilean", "Soraka", "Nocturne", "Jinx", "Yorick", "Urgot", "Kindred", "MissFortune", "Blitzcrank", "Shen", "Braum", "XinZhao", "Twitch", "MasterYi", "Taric", "Amumu", "Gangplank", "Trundle", "Kassadin", "Velkoz", "Zyra", "Nami", "JarvanIV", "Ezreal", "MonkeyKing"]
    name = name.gsub(/\W+/, '')
    if name.downcase == "wukong"
      return "MonkeyKing"
    end
    champ_keys.each do |champ|
      if name.downcase == champ.downcase
        return champ
      end
    end

    name
  end

	def self.call(url)
		sleep 0.01
		request = {:url => url, :method => :get, :verify_ssl => false}
		response = RestClient::Request.execute(request)
		JSON.parse(response)
	end
end
