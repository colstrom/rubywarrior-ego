require 'contracts'
require_relative 'ego/memory'
require_relative 'ego/path_finding'
require_relative 'ego/self_preservation'
require_relative 'ego/spatial_awareness'
require_relative 'ego/tactics'

class Ego
  include ::Contracts::Core
  include ::Contracts::Builtin
  include SpatialAwareness
  include Memory
  include PathFinding
  include SelfPresevation
  include Tactics

  Contract ::RubyWarrior::Turn => Ego
  def initialize(id)
    @id = id
    self
  end

  def acted?
    @acted ||= false
  end

  def actions
    @actions ||= (remembered(:actions) || [])
  end

  def acted!
    @acted = true
  end

  def track(action)
    actions.push(action).tap { acted! }
  end

  def record_journey
    remember :path, path
    remember :wounds, wounds
    remember :actions, actions
  end

  def act
    tactics
    record_journey
  end

  def method_missing(method, *args)
    return super unless @id.respond_to? method

    if method.to_s.end_with? '!'
      @id.public_send(method, *args).tap { track method } unless acted?
    else
      @id.public_send(method, *args)
    end
  end

  def respond_to?(method)
    @id.respond_to?(method) || super
  end
end
