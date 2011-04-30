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
    @queue.shift
  end
  delegate :length, :to => :@queue
  private
  
  def sort
    @queue.sort! &@sorter
  end
end