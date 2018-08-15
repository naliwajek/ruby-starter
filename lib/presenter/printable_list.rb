module Presenter
  class PrintableList
    def initialize(title:)
      @title = title
    end

    def present(array_with_count:)
      result = ''

      array_with_count.each do |line|
        result += "#{line[0]} #{line[1]} #{title}\n"
      end

      result
    end

    private

    attr_reader :title
  end
end