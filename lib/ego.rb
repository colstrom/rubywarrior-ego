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

  def action(*args)
    return unless @id.respond_to? __callee__
    @id.send(__callee__, *args)
  end

  alias feel action
  alias health action
  alias look action

  def track(action)
    actions.push(action).tap { acted! }
  end

  def action!(*args)
    return if acted?
    return unless @id.respond_to? __callee__
    @id.send(__callee__, *args).tap { track __callee__ } unless acted?
  end

  alias walk! action!
  alias attack! action!
  alias rest! action!
  alias rescue! action!
  alias pivot! action!
  alias shoot! action!

  def record_journey
    remember :path, path
    remember :wounds, wounds
    remember :actions, actions
  end

  def act
    tactics
    record_journey
  end
end
