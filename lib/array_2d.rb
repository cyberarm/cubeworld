class CubeWorld
  class Array2D
    def initialize(initial_x_size = 3, initial_y_size = 3)
      @array = Array.new(initial_x_size) {Array.new(initial_y_size)}
    end

    def all(&block)
      @array.each do |x|
        x.each do |y|
          yield(y) if y != nil
        end
      end
    end

    def set(x, y, value)
      if @array[x].nil?
        (x-(@array.size-1)).times {@array.push([])}
      end

      if @array[x][y].nil?
        (y-(@array.size-1)).times {@array.push([])}
      end

      @array[x][y] = value
    end

    def exist?(x, y)
      begin
        return @array[x][y]
      rescue
        return false
      end
    end

    def get(x, y)
      begin
        return @array[x][y]
      rescue NilClass
        return nil
      end
    end

    def width; @array.size; end
    def height(x = 0); @array[x].size; end
  end
end