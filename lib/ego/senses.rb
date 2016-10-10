require 'contracts'

module Senses
  SENSES = %i(feel look listen).freeze

  def senses
    SENSES.select { |sense| respond_to? sense }
  end

  def numb?
    !senses.include? :feel
  end

  def blind?
    !senses.include? :look
  end

  def deaf?
    !senses.include? :listen
  end
end
