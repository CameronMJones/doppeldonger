require 'lib/donger_rest'
require 'lib/donger_graph'

begin
	graph = DongerGraph.new()
	champions = DongerRest.get_champions()["data"]
	champions.each do |key, value| 
		graph.add_champion(value["id"], value["name"], value["title"])
	end
rescue
	puts 'Startup Failed'
end