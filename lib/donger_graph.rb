require_relative 'donger_string'
require 'neography'

class DongerGraph
	attr_accessor :neo

	def initialize()
		@neo = Neography::Rest.new(ENV["GRAPHSTORY_URL"])
	end

	def add_champion(id, name, title)
		sanitized_name = DongerString.sanitize(name)
		query = "MERGE (c:Champion{id:{id}})
				ON CREATE SET
				c.name = {name},
				c.id = {id},
				c.title = {title}"
		@neo.execute_query(query, {:id => id, :name => sanitized_name, :title => title})
	end

	def add_summoner(id, name)
		sanitized_name = DongerString.sanitize(name)
		query = "MERGE (s:Summoner{id:{id}})
				ON CREATE SET
				s.name = {name},
				s.id = {id},
				s.updated = timestamp()
				ON MATCH SET
				s.name = {name},
				s.updated = timestamp()"
		@neo.execute_query(query,{:id => id, :name => sanitized_name})
	end

	def add_mastery(summoner_id, champion_id, points)
		query = "MATCH (s:Summoner{id:{summoner_id}}),
				(c:Champion{id:{champion_id}})
				CREATE UNIQUE (s)-[m:MASTERS]->(c)
				SET m.points = {points}"
		@neo.execute_query(query, {:summoner_id => summoner_id, :champion_id => champion_id, :points => points})
	end

	def sanitize_mastery(id)
		query = "MATCH (s:Summoner{id:{id}})-[m1:MASTERS]->(c1:Champion)
				WITH m1
				ORDER BY m1.points desc
				SKIP 3
				DELETE m1"
		@neo.execute_query(query, {:id => id})
	end

	def get_mastery(name)
		sanitized_name = DongerString.sanitize(name)
		query = "MATCH (s:Summoner)-[m:MASTERS]->(c:Champion)
				WHERE s.name={name}
				RETURN s,m,c"
		@neo.execute_query(query, {:name => sanitized_name})
	end

	def add_attribute(name)
		query = "MERGE (a:Attribute{name:{name}})
				ON CREATE SET
				a.name = {name}
				ON MATCH SET
				a.name = {name}"
		@neo.execute_query(query, {:name => name})
	end

	def add_exhibits(champion_id, name)
		query = "MATCH (c:Champion{id:{champion_id}}),
				(a:Attribute{name:{name}})
				CREATE UNIQUE (c)-[e:EXHIBITS]->(a)"
		@neo.execute_query(query, {:champion_id => champion_id, :name => name})
	end

	def get_popular_picks(name)
		sanitized_name = DongerString.sanitize(name)
		query = "MATCH (s1:Summoner)-[:MASTERS]->(c1:Champion),
				(s1)-[:MASTERS]->(c2:Champion),
				(s2:Summoner)-[:MASTERS]->(c1),
				(s2)-[:MASTERS]->(c2),
				(s2)-[:MASTERS]->(c3:Champion)
				WHERE s1.name = {name}
				AND NOT (s1)-[:MASTERS]->(c3)
				RETURN c3, count(c3) as Frequency
				ORDER BY Frequency DESC
				LIMIT 3"
		@neo.execute_query(query, {:name => sanitized_name})
	end

	def get_attributes(name)
		sanitized_name = DongerString.sanitize(name)
		query =	"MATCH (s1:Summoner)-[:MASTERS]->(c1:Champion)-[:EXHIBITS]->(a1:Attribute)
				WHERE s1.name = {name}
				RETURN a1 as Attribute, count(a1) as Total
				ORDER BY Total DESC
				LIMIT 3"
		@neo.execute_query(query, {:name => sanitized_name})
	end

	def get_uniqueness(name)
		sanitized_name = DongerString.sanitize(name)
		query = "MATCH (s1:Summoner)-[:MASTERS]->(c1:Champion),
						(s2:Summoner)-[:MASTERS]->(c1)
						WHERE s1.name = {name}
						WITH s2, count(s2) As Frequency
						RETURN Frequency, count(Frequency)"
		@neo.execute_query(query, {:name => sanitized_name})
	end

end
