class CubeWorld
  class WorldGenerator
    def initialize(seed: rand(10_000..99_999), chunk_size: 8, width: 4, height: 4)
      @seed = seed
      @chunk_size = chunk_size
      @width = width
      @height = height

      @interval = 1
      @persistence, @octaves = 1.0, 1
      @generator = Perlin::Generator.new(@seed, @persistence, @octaves)

      @chunks = Array2D.new

      @kp = 1.0

      puts "WorldGenerator Seed: #{seed}"

      width.times do |x|
        height.times do |y|
          generate_chunk(x, y)
        end
      end
    end

    def generate_chunk(x, y)
      chunk = Chunk.new(x, y, @chunk_size)
      noise = @generator.chunk(x / @kp, y / @kp, @chunk_size, @chunk_size, @interval) do |n, _x, _y|
        # p "#{_x.round}:#{_y.round} -> #{n}"
        chunk.add_block(_x.round, _y.round, n)
      end
      @chunks.set(x, y, chunk)
    end

    def draw_world
      # Science #
      @chunks.all do |chunk|
        chunk.draw
      end
    end
  end

  class Chunk
    def initialize(x, y, chunk_size)
      @x,@y = x,y
      @block_size = 16
      @blocks = Array2D.new(chunk_size, chunk_size)
      @chunk_size = chunk_size
    end

    def add_block(x, y, noise)
      type = Block::DIRT

      if noise <= -1.0
        type = Block::WOOD#Block::AIR
      elsif noise < 0.5
        type = Block::GRASS
      elsif noise < 0.7
        type = Block::SAND
      elsif noise >= 0.8
        type = Block::WATER
      else
        type = Block::DIRT
      end

      begin
        @blocks.set(x, y, type)
      # rescue => e
        # p e
      end
    end

    def draw
      @blocks.width.times do |x|
        @blocks.height(x).times do |y|
          begin
            color = Block.from_id(@blocks.get(x, y))[:color]
          rescue RuntimeError
            next
          end

          Gosu.draw_rect(x*(@x*@block_size), y*(@y*@block_size), @block_size, @block_size, color)
        end
      end
    end
  end
end