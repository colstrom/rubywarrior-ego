require 'pry'
require_relative 'lib/ego'

class Player
  def as(warrior, &block)
    warrior.instance_eval(&block)
  end

  def history
    @history ||= []
  end

  def play_turn(warrior)
    ego = Ego.new warrior
    ego.recall(history.last || {})
    ego.act
    history << ego.memories
  end
end
