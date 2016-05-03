require 'neography'

class DongerGraph
	attr_accessor :neo

	def initialize()
		@neo = Neography::Rest.new(ENV["GRAPHSTORY_URL"])
	end

	def add_champion(id, name, title)
		node = @neo.create_node("id" => id, "name" => name, "title" => title)
		@neo.add_label(node, "Champion")
		node
	end

	def find_champion(id)
		@neo.find_nodes_labeled("Champion", {:id => id})[0]
	end

	def add_summoner(id, name)
		node = @neo.create_node("id" => id, "name" => name)
		@neo.add_label(node, "Summoner")
		node
	end

	def connect_mastery(summoner, champion, points)
		relation = @neo.create_relationship("MASTERS", summoner, champion)
		@neo.set_relationship_properties(relation, {"points" => points})
		relation
	end

	def add_trait(name, description)
		node = @neo.create_node("name" => name, "description" => description)
		@neo.add_label(node, "Trait")
		node
	end

	def connect_trait(trait, champion)
		relation = @neo.create_relationship("EXHIBITS", traits, champion)
		relation
	end

	def recommend(summoner_name)
		query = "MATCH (s1:Summoner)-[:MASTERS]->(c1:Champion)<-[:MASTERS]-(s2:Summoner)-[:MASTERS]->(c2:Champion)<-[:MASTERS]-(s1),
						(s2)-[:MASTERS]->(c3:Champion)
						WHERE s1.name = \"#{summoner_name}\"
						AND NOT (s1)-[:MASTERS]->(c3)
						RETURN c3, count(distinct c3) as frequency
						ORDER BY frequency DESC
						LIMIT 3"
		@neo.execute_query(query)
	end

end