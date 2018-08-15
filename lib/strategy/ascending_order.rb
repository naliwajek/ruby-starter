module Strategy
  class AscendingOrder
    def self.execute(hash:)
      hash.sort_by { |_, v| v }
    end
  end
end