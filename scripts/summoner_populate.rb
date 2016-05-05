require './lib/donger_rest'
require './lib/donger_graph'

def get_sample_names()
	begin
		games = DongerRest.get_games()["gameList"]
		players = games.map{|game| game["participants"]}.flatten
		names = players.map{|player| player["summonerName"]}
	rescue Exception => ex
		puts "Error retrieving featured game list: #{ex.message}"
		exit
	end
end

def get_sample_ids(names)
	begin
		sliced_names = names.each_slice(40).to_a
		summoners = sliced_names.map{|names| DongerRest.get_summoners(names).values}
		summoners.flatten.map{|summoner| summoner["id"]}
	rescue Exception => ex
		puts "Error retrieving summoner ids: #{ex.message}"
		exit
	end
end

def get_sample_players(ids)
	sliced_ids = ids.each_slice(10).to_a
	leagues = []
	sliced_ids.each do |ids|
		begin	
			leagues = leagues + DongerRest.get_leagues(ids).values.flatten
		rescue Exception => ex
			puts "Error retrieving leagues: #{ex.message}"
			next
		end
	end
	solo_queue = leagues.select{|league| league["queue"]=="RANKED_SOLO_5x5"}
	solo_queue.map{|league| league["entries"]}.flatten.uniq!
end

graph = DongerGraph.new()
sample_names = get_sample_names()
sample_ids = get_sample_ids(sample_names)
sample_players = get_sample_players(sample_ids)

sample_players.each do |player|
	id = player ["playerOrTeamId"]
	name = player["playerOrTeamName"]
	begin
		masteries = DongerRest.get_masteries(id)
		next if masteries.length == 0
	rescue Exception => ex
		puts "Error retrieving masteries: #{ex.message}"
		next
	end

	graph.add_summoner(id, name)
	masteries.each do |mastery|
		graph.add_mastery(id, mastery["championId"], mastery["championPoints"])
	end

	puts "Added mastery for #{name}"
end