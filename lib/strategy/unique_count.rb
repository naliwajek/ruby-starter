module Strategy
  class UniqueCount
    def self.execute(array:)
      array.uniq.count
    end
  end
end