class CubeWorld

  class WorldGenerator
    attr_reader :seed, :chunk_size, :block_size, :width, :height, :chunks

    def initialize(seed: SecureRandom.hex(64).to_i, chunk_size: 16, block_size: 4, width: 4, height: 4)
      # DateTime.now.strftime("%Q").to_i #
      @seed = seed
      @chunk_size = chunk_size
      @block_size = block_size
      @width = width
      @height = height

      @interval = 1
      @persistence, @octaves = rand(0.0..1.0), rand(1.0..100.0)
      @generator = Perlin::Generator.new(@seed, @persistence, @octaves)

      @chunks = Array2D.new

      @kp = 100.0

      puts "WorldGenerator Seed: #{seed}, Persistence: #{@persistence}, Octaves: #{@octaves}"

      # width.times do |x|
      #   height.times do |y|
      #     generate_chunk(x, y)
      #   end
      # end
    end

    def generate_chunk(x, y)
      chunk = Chunk.new(x, y, @chunk_size, @block_size)
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
    def initialize(x, y, chunk_size, block_size)
      @x,@y = x,y
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
      Gosu.translate(@x*(@block_size*@chunk_size), @y*(@block_size*@chunk_size)) do

        @image ||= Gosu.record(@block_size*@chunk_size, @block_size*@chunk_size) do
          @blocks.width.times do |x|
            @blocks.height(x).times do |y|
              begin
                color = Block.from_id(@blocks.get(x, y))[:color]
              rescue RuntimeError
                next
              end

              Gosu.draw_rect(x*@block_size, y*@block_size, @block_size, @block_size, color)
            end
          end
        end
      end

      @image.draw(@x*(@block_size*@chunk_size), @y*(@block_size*@chunk_size), 0)
    end
  end
end