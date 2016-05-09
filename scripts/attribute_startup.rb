require './lib/donger_constants'
require './lib/donger_graph'

graph = DongerGraph.new()

graph.add_attribute(DongerConstants::HIGH_DEFENSE)
graph.add_attribute(DongerConstants::LOW_DEFENSE)
graph.add_attribute(DongerConstants::BALANCED_DEFENSE)

graph.add_attribute(DongerConstants::HIGH_DIFFICULTY)
graph.add_attribute(DongerConstants::LOW_DIFFICULTY)
graph.add_attribute(DongerConstants::BALANCED_DIFFICULTY)

graph.add_attribute(DongerConstants::HYBRID_DAMAGE)
graph.add_attribute(DongerConstants::ABILITY_DAMAGE)
graph.add_attribute(DongerConstants::ATTACK_DAMAGE)

graph.add_attribute(DongerConstants::FIGHTER_ROLE)
graph.add_attribute(DongerConstants::TANK_ROLE)
graph.add_attribute(DongerConstants::SUPPORT_ROLE)
graph.add_attribute(DongerConstants::MAGE_ROLE)
graph.add_attribute(DongerConstants::MARKSMAN_ROLE)
graph.add_attribute(DongerConstants::ASSASSIN_ROLE)


graph.add_attribute(DongerConstants::SLOW)
graph.add_attribute(DongerConstants::STUN)
graph.add_attribute(DongerConstants::ROOT)
graph.add_attribute(DongerConstants::SHIELD)
graph.add_attribute(DongerConstants::HEAL)
graph.add_attribute(DongerConstants::MOVEMENT)
graph.add_attribute(DongerConstants::HEALTH_DAMAGE)
graph.add_attribute(DongerConstants::ARMOR)
graph.add_attribute(DongerConstants::ATTACK_SPEED)
graph.add_attribute(DongerConstants::SILENCE)
graph.add_attribute(DongerConstants::PASSIVE)
graph.add_attribute(DongerConstants::JUMP)
graph.add_attribute(DongerConstants::DISPLACE)
graph.add_attribute(DongerConstants::MARK)
graph.add_attribute(DongerConstants::POISON)
graph.add_attribute(DongerConstants::ZONE)
graph.add_attribute(DongerConstants::FIRES)
graph.add_attribute(DongerConstants::STACKS)
graph.add_attribute(DongerConstants::MAGIC_RESIST)
graph.add_attribute(DongerConstants::SUMMONS)
graph.add_attribute(DongerConstants::TRUE_DAMAGE)