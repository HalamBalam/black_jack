class User < Player
  def description
    "->#{name} (#{cash}$)"
  end
end
