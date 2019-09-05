class CubeWorld

  class WorldGenerator
    attr_reader :seed, :chunk_size, :block_size, :width, :height, :chunks

    def initialize(seed: SecureRandom.hex(2), chunk_size: 16, block_size: 4, width: 4, height: 4)
      # DateTime.now.strftime("%Q").to_i #
      p seed
      @seed = seed.hex
      raise "Seed was < 1!" if @seed < 1

      @chunk_size = chunk_size
      @block_size = block_size
      @width = width
      @height = height

      @interval = 32
      @persistence = 0.0173
      @octaves     = 3
      @kp = 1.0 / 10.0

      @generator = Perlin::Generator.new(@seed, @persistence, @octaves)

      @chunks = Array2D.new


      puts "WorldGenerator Seed: #{@seed}, Persistence: #{@persistence}, Octaves: #{@octaves}"
    end

    def generate_chunk(x, y)
      chunk = Chunk.new(x, y, @chunk_size, @block_size)

      @generator = Perlin::Generator.new(@seed, @persistence, @octaves)
      puts "WorldGenerator Seed: #{@seed}, Persistence: #{@persistence}, Octaves: #{@octaves}"


      _x = 0
      _y = 0
      noise = @generator.chunk(x * @kp, y * @kp, @chunk_size, @chunk_size, @interval) do |noise_x, noise_y, noise_z|
        chunk.add_block(_x, _y, noise_x)
        _x += 1

        if _x >= @chunk_size
          _x = 0
          _y += 1
        end
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
    def initialize(x, y, chunk_size, block_size)
      @x,@y = x, y
      @blocks = Array2D.new(chunk_size, chunk_size)

      @chunk_size = chunk_size
      @block_size = block_size

      @image = nil
    end

    def add_block(x, y, noise)
      type = Block::DIRT

      if noise <= -0.0
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

      @blocks.set(x, y, type)
    end

    def draw
      Gosu.translate(@x * (@block_size + @chunk_size), @y * (@block_size + @chunk_size)) do

        @image ||= Gosu.record(@block_size + @chunk_size, @block_size + @chunk_size) do
          @blocks.width.times do |x|
            @blocks.height(x).times do |y|
              begin
                color = Block.from_id(@blocks.get(x, y))[:color]
              rescue RuntimeError
                next
              end

              Gosu.draw_rect(x * @block_size, y * @block_size, @block_size, @block_size, color)
            end
          end
        end
      end

      @image.draw(@x*(@block_size*@chunk_size), @y*(@block_size*@chunk_size), 0)
    end
  end
end