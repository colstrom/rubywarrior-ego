require 'contracts'

module SpatialAwareness
  include ::Contracts::Core
  include ::Contracts::Builtin

  DIRECTIONS = %i(forward backward left right).freeze
  Direction = Enum[*DIRECTIONS]

  def feelings
    feel.class.instance_methods(false).select { |m| m.to_s.end_with? '?' }
  end

  Contract None => HashOf[Direction, ArrayOf[Symbol]]
  def surroundings
    DIRECTIONS.map do |direction|
      [
        direction,
        feelings
          .select { |feeling| feel(direction).send feeling }
          .map { |feeling| feeling.to_s.chomp('?').to_sym }
      ]
    end.to_h
  end

  Contract None => HashOf[Symbol, ArrayOf[Direction]]
  def adjacent
    surroundings.values.flatten.uniq.map do |thing|
      [thing, surroundings.select { |_, things| things.include? thing }.keys]
    end.to_h
  end

  Contract Symbol => ArrayOf[Direction]
  def adjacent(thing)
    adjacent.fetch(thing) { [] }
  end

  Contract None => HashOf[Direction, ArrayOf[Symbol]]
  def visible
    DIRECTIONS.map do |direction|
      [
        direction,
        feelings
          .select { |feeling| look(direction).any? { |space| space.send feeling } }
          .map { |feeling| feeling.to_s.chomp('?').to_sym }
      ]
    end.to_h
  end

  Contract None => HashOf[Symbol, ArrayOf[Direction]]
  def nearby
    visible.values.flatten.uniq.map do |thing|
      [thing, visible.select { |_, things| things.include? thing }.keys]
    end.to_h
  end

  Contract Symbol => ArrayOf[Direction]
  def nearby(thing)
    nearby.fetch(thing) { [] }
  end

  Contract Maybe[Direction] => Any # HashOf[Direction, ArrayOf[Any]]
  def units(direction = nil)
    if direction
      { direction => look(direction).map(&:unit).compact }
    else
      DIRECTIONS.map { |d| units d }.reduce(&:merge)
    end
  end
end
