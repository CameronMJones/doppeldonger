require './lib/donger_rest'
require './lib/donger_graph'

graph = DongerGraph.new()

begin
	games = DongerRest.get_games()["gameList"]
	players = games.map{|game| game["participants"]}.flatten
	names = players.map{|player| player["summonerName"]}
rescue Exception => ex
	puts "Error retrieving featured game list: #{ex.message}"
	exit
end

names.each do |name|
	begin
		sleep 2
		id = DongerRest.get_summoner_id(name).values.first["id"]
	rescue Exception => ex
		puts "Error retrieving summoner id for #{name}: #{ex.message}"
		next
	end

	begin
		sleep 2
		masteries = DongerRest.get_masteries(id)
		next if masteries.length == 0
	rescue Exception => ex
		puts "Error retrieving masteries for #{name}: #{ex.message}"
		next
	end

	graph.add_summoner(id, name)
	masteries.each do |mastery|
		graph.add_mastery(id, mastery["championId"], mastery["championPoints"])
	end

end