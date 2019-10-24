class Player
  attr_accessor :name
  attr_reader :token

  def initialize(token, name = "the player")
    @token = token
    @name = name
  end
end
