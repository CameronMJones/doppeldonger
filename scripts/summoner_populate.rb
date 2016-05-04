require './lib/donger_rest'
require './lib/donger_graph'

graph = DongerGraph.new()

begin
	games = DongerRest.get_games()["gameList"]
	players = games.map{|game| game["participants"]}.flatten
	names = players.map{|player| player["summonerName"]}
rescue
	puts 'Could not retrieve featured games'
	exit
end

names.each do |name|
	begin
		id = DongerRest.get_summoner_id(name)
	rescue
		puts "Could not retrieve id for Summoner: #{name}"
		next
	end

	begin 
		masteries = DongerRest.get_masteries(id)
		next if masteries.length == 0
	rescue
		puts "Could not retrieve masteries for summoner: #{name}"
		next
	end

	summoner = graph.add_summoner(id, name)
	masteries.each do |mastery|
		champion = graph.find_champion(mastery["championId"])
		graph.connect_mastery(summoner, champion, mastery["championPoints"])
	end

end