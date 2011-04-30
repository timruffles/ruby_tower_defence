class SortedQueue
  def initialize queue = [], &sorter
    @sorter = sorter
    @queue = queue
    sort
  end
  def add items
    @queue.concat items
    sort
  end
  def next
    @queue.unshift
  end
  
  private
  
  def sort
    @queue.sort! &@sorter
  end
end