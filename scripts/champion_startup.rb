require './lib/donger_rest'
require './lib/donger_graph'
require './lib/donger_constants'

begin
	results = DongerRest.get_champion_info()
	champions = results[data]
	champions.each |champion, data| do
		add_champion(data)
		add_defense(data)
		add_difficulty(data)
		add_damage(data)
		add_role(data)
		add_abilities(data)
	end
rescue => ex
	puts "Startup Failed: #{ex.message}"
end

def add_champion(data)
	graph = DongerGraph.new()
	id = data["id"]
	name = data["name"]
	title = data["title"]
	graph.add_champion(id, name, title)
end

def add_defense(data)
	graph = DongerGraph.new()
	id = data["id"]
	defense = data["info"]["defense"]
	if defense >= 7
		graph.add_exhibits(id, DongerConstants::HIGH_DEFENSE)
	elsif defense <= 3
		graph.add_exhibits(id, DongerConstants::LOW_DEFENSE)
	else
		graph.add_exhibits(id, DongerConstants::BALANCED_DEFENSE)
	end
end

def add_difficulty(data)
	graph = DongerGraph.new()
	id = data["id"]
	difficulty = stats["info"]["difficulty"]
	if difficulty >= 7
		graph.add_exhibits(id, DongerConstants::HIGH_DIFFICULTY)
	elsif difficulty <= 3
		graph.add_exhibits(id, DongerConstants::LOW_DIFFICULTY)
	else
		graph.add_exhibits(id, DongerConstants::BALANCED_DIFFICULTY)
	end
end

def add_damage(data)
	graph = DongerGraph.new()
	id = stats["id"]
	magic = stats["info"]["magic"]
	attack = stats["info"]["attack"]
	if (magic - attack).abs <= 2
		graph.add_exhibits(id, DongerConstants::HYBRID_DAMAGE)
	elsif magic > attack
		graph.add_exhibits(id, DongerConstants::ABILITY_DAMAGE)
	else
		graph.add_exhibits(id, DongerConstants::ATTACK_DAMAGE)
	end
end

def add_role(data)
	graph = DongerGraph.new()
	id = data["id"]
	data["tags"].each{|role| graph.add_exhibits(id, role)}
end

def add_abilities(data)
	graph = DongerGraph.new()
	id = data["id"]
	labels = data["spells"].map{|spell| spell["leveltip"]["label"]}.flatten.join("|").downcase
	descriptions = data["spells"].map{|spell| spell["description"]}.flatten.join("|").downcase
	keywords = labels + "|" + descriptions
	graph.add_exhibits(id, DongerConstants::SLOW) if keywords.include? "slow"
	graph.add_exhibits(id, DongerConstants::STUN) if keywords.include? "stun"
	graph.add_exhibits(id, DongerConstants::ROOT) if keywords.include? "root"
	graph.add_exhibits(id, DongerConstants::SHIELD) if keywords.include? "shield"
	graph.add_exhibits(id, DongerConstants::HEAL) if is_heal(keywords)
	graph.add_exhibits(id, DongerConstants::MOVEMENT) if keywords.include? "movement"
	graph.add_exhibits(id, DongerConstants::HEALTH_DAMAGE) if keywords.include? "health damage"
	graph.add_exhibits(id, DongerConstants::ARMOR) if keywords.include? "armor"
	graph.add_exhibits(id, DongerConstants::ATTACK_SPEED) if keywords.include? "attack speed"
	graph.add_exhibits(id, DongerConstants::SILENCE) if keywords.include? "silence"
	graph.add_exhibits(id, DongerConstants::JUMP) if is_jump(keywords)
	graph.add_exhibits(id, DongerConstants::PASSIVE) if keywords.include? "passive"
	graph.add_exhibits(id, DongerConstants::DISPLACE) if is_displace(keywords)
	graph.add_exhibits(id, DongerConstants::MARK) if keywords.include? "mark"
	graph.add_exhibits(id, DongerConstants::POISON) if keywords.include? "poison"
	graph.add_exhibits(id, DongerConstants::ZONE) if keywords.include? "zone"
	graph.add_exhibits(id, DongerConstants::FIRES) if keywords.include? "fires"
	graph.add_exhibits(id, DongerConstants::STACKS) if keywords.include? "stack"
	graph.add_exhibits(id, DongerConstants::MAGIC_RESIST) if keywords.include? "magic resist"
	graph.add_exhibits(id, DongerConstants::MAGIC_RESIST) if keywords.include? "summons"
	graph.add_exhibits(id, DongerConstants::TRUE_DAMAGE) if keywords.include? "true damage"
end

def is_jump
	return keywords.include?("leap")||keywords.include?("teleport")||keywords.include?("dash")
end

def is_heal(keywords)
	return keywords.include?("heal")||keywords.include?("restor")||keywords.include?("regen")
end

def is_displace(keywords)
	return keywords.include?("grab")||keywords.include?("knock")
end
