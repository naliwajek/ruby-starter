module Strategy
  class DescendingOrder
    def self.execute(hash:)
      hash.sort_by { |_, v| -v }
    end
  end
end