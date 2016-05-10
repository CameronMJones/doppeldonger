require './lib/donger_rest'
require './lib/donger_graph'
require './lib/donger_constants'

def add_champion(data, graph)
	id = data["id"]
	name = data["name"]
	title = data["title"]
	skin = data["key"] + "_0.jpg"
	graph.add_champion(id, name, title, skin)
end

def add_spells(data, graph)
	id = data["id"]
	spells = data["spells"].each_with_index do |info, index|
		name = info["name"]
		image = info["image"]["full"]
		description = info["description"]
		graph.add_spell(index+1, name, image, description)
		graph.add_uses(id, name)
	end
	passive = data["passive"]
	graph.add_spell(0, passive["name"], passive["image"]["full"], passive["description"])
	graph.add_uses(id, passive["name"])
end

def add_defense(data, graph)
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

def add_difficulty(data, graph)
	id = data["id"]
	difficulty = data["info"]["difficulty"]
	if difficulty >= 7
		graph.add_exhibits(id, DongerConstants::HIGH_DIFFICULTY)
	elsif difficulty <= 3
		graph.add_exhibits(id, DongerConstants::LOW_DIFFICULTY)
	else
		graph.add_exhibits(id, DongerConstants::BALANCED_DIFFICULTY)
	end
end

def add_damage(data, graph)
	id = data["id"]
	magic = data["info"]["magic"]
	attack = data["info"]["attack"]
	if (magic - attack).abs <= 2
		graph.add_exhibits(id, DongerConstants::HYBRID_DAMAGE)
	elsif magic > attack
		graph.add_exhibits(id, DongerConstants::ABILITY_DAMAGE)
	else
		graph.add_exhibits(id, DongerConstants::ATTACK_DAMAGE)
	end
end

def add_role(data, graph)
	id = data["id"]
	data["tags"].each{|role| graph.add_exhibits(id, role)}
end

def add_abilities(data, graph)
	id = data["id"]
	labels = data["spells"].map{|spell| spell["leveltip"]["label"]}.flatten.join("|").downcase
	descriptions = data["spells"].map{|spell| spell["description"]}.flatten.join("|").downcase
	keywords = labels + "|" + descriptions
	graph.add_exhibits(id, DongerConstants::SLOW) if keywords.include? "slow"
	graph.add_exhibits(id, DongerConstants::STUN) if keywords.include? "stun"
	graph.add_exhibits(id, DongerConstants::ROOT) if is_root(keywords)
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
	graph.add_exhibits(id, DongerConstants::ZONE) if is_zone(keywords)
	graph.add_exhibits(id, DongerConstants::FIRES) if keywords.include? "fires"
	graph.add_exhibits(id, DongerConstants::STACKS) if keywords.include? "stack"
	graph.add_exhibits(id, DongerConstants::MAGIC_RESIST) if keywords.include? "magic resist"
	graph.add_exhibits(id, DongerConstants::SUMMONS) if keywords.include? "summons"
	graph.add_exhibits(id, DongerConstants::TRUE_DAMAGE) if keywords.include? "true damage"
end

def is_root(keywords)
	return keywords.include?("root")||keywords.include?("binds")
end

def is_jump(keywords)
	return keywords.include?("leap")||keywords.include?("teleport")||keywords.include?("dash")
end

def is_heal(keywords)
	return keywords.include?("heal|")||keywords.include?("health restor")||keywords.include?("health regen")
end

def is_displace(keywords)
	return keywords.include?("grab")||keywords.include?("knock")
end

def is_zone(keywords)
	return keywords.include?("zone")||keywords.include?("area")
end

begin
	graph = DongerGraph.new()
	results = DongerRest.get_champion_info()
	champions = results["data"]
	champions.each do |champion, data|
		puts "Adding Champion: #{champion}"
		add_champion(data, graph)
		add_spells(data, graph)
		add_defense(data, graph)
		add_difficulty(data, graph)
		add_damage(data, graph)
		add_role(data, graph)
		add_abilities(data, graph)
	end
rescue => ex
	puts "Startup Failed: #{ex.message}"
end
