module HasIdentity
  def id
    @has_identity ||= HasIdentity.uuid.generate
  end
  @uuid = UUID.new
  class << self
    attr_reader :uuid
  end
end