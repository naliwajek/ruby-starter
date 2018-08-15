require 'json'

module Presenter
  class JsonResponse
    def initialize(title:)
      @title = title
    end

    def present(array_with_count:)
      result = []

      array_with_count.each_with_index do |elem, index|
        result << {
          position: index,
          url: elem[0],
          count: elem[1]
        }
      end

      {
        type: title,
        views: result
      }.to_json
    end

    private

    attr_reader :title
  end
end