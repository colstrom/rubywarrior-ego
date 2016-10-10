require_relative 'memory'
require_relative 'spatial_awareness'

module PathFinding
  include Memory
  include SpatialAwareness

  OPPOSITES = DIRECTIONS.each_slice(2).to_h

  def opposite(direction)
    OPPOSITES.fetch(direction) { OPPOSITES.invert.fetch direction }
  end

  def path
    @path ||= (remembered(:path) || [])
  end

  def advance(direction = :forward)
    path.push(direction) if walk! direction
  end

  def retreat
    return if engaging_archer?
    path.pop if walk! opposite(path.last || :forward)
  end

  def engaging_archer?
    adjacent(:enemy).any? { |enemy| feel(enemy).character == 'a' }
  end
end
