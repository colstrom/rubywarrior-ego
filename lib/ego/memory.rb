module Memory
  def memories
    @memories ||= {}
  end

  def recall(memories)
    @memories = memories
  end

  def remember(memory, details)
    memories.store memory, details
  end

  def remembered(memory)
    memories[memory]
  end

  def forget(memory)
    memories.delete memory
  end
end
