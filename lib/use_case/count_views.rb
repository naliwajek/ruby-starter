module UseCase
  class CountViews
    def initialize(file_gateway:, count_strategy:, order_strategy:)
      @file_gateway = file_gateway
      @count_strategy = count_strategy
      @order_strategy = order_strategy
    end

    def execute(presenter:)
      visits = sort(count(hash_of_visits))

      presenter.present(array_with_count: visits)
    end

    private

    def hash_of_visits
      lines = file_gateway.readlines

      Hash.new.tap do |views|
        lines.each do |line|
          url, ip = line.split(/\s+/)
          views[url] = (views[url] || []) << ip
        end
      end
    end

    def count(visits)
      visits.each do |k, v|
        visits[k] = count_strategy.execute(array: v)
      end
    end

    def sort(counted_visits)
      order_strategy.execute(hash: counted_visits)
    end

    attr_reader :file_gateway, :count_strategy, :order_strategy
  end
end