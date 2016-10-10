require_relative 'memory'
require_relative 'spatial_awareness'

module SelfPresevation
  include Memory
  include SpatialAwareness

  MAX_HEALTH = 20
  HEALING_RATE = 0.1

  def safe?
    adjacent(:enemy).empty? && !taking_ranged_damage?
  end

  def wounds
    MAX_HEALTH - (respond_to?(:health) ? health : MAX_HEALTH)
  end

  def taking_damage?
    wounds > (remembered(:wounds) || 0)
  end

  def taking_ranged_damage?
    taking_damage? && ([:walk!, :rest!].include? actions.last)
  end

  def wounded?
    true unless wounds.zero?
  end

  def worth_resting?
    wounds >= recoverable && look.find(&:enemy?)
  end

  def recoverable
    MAX_HEALTH * HEALING_RATE
  end

  def recover
    return unless wounded?
    rest! if safe?
    retreat if worth_resting? && !taking_ranged_damage?
  end

  def avoid_facing_walls
    return unless adjacent(:wall).include? :forward
    pivot! :backward
  end

  def archers
    nearby(:enemy).select do |direction|
      look(direction).reject(&:empty?).first.character == 'a'
    end
  end
end
