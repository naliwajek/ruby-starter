module Gateway
  class File
    def initialize(path:)
      @path = path
    end

    def readlines
      ::File.readlines(path).map(&:strip)
    end

    private

    attr_reader :path
  end
end
