require_relative 'self_preservation'
require_relative 'spatial_awareness'

module Tactics
  include SpatialAwareness
  include SelfPresevation

  def mitigate
    avoid_facing_walls
    recover
  end

  def liberate
    adjacent(:captive).each { |captive| rescue! captive }
    nearby(:captive).each { |captive| advance captive }
  end

  def engage
    adjacent(:enemy).each { |enemy| attack! enemy }

    archers.each { |archer| shoot! archer }

    (nearby(:enemy) - nearby(:captive)).each do |enemy|
      shoot! enemy
    end
  end

  def tactics
    mitigate
    liberate
    engage
    advance
  end
end
