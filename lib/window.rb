class CubeWorld
  class Window < Gosu::Window
    def self.instance=(i)
      @instance = i
    end

    def self.instance
      return @instance
    end

    def initialize
      super(Gosu.available_width / 4 * 3, Gosu.available_height / 4 * 3, fullscreen: false)
      self.caption = "CubeWorld - A Ruby Voxel Adventure"

      @world_generator = WorldGenerator.new
      @font = Gosu::Font.new(24, name: "Consolas")
    end

    def draw
      Gosu.draw_rect(self.mouse_x-2, self.mouse_y-2, 4, 4, Gosu::Color::RED, Float::INFINITY) if @_x && @_y

      @font.draw_text("FPS: #{Gosu.fps}", 6, 6, 10, 1,1, Gosu::Color::BLACK)
      @font.draw_text("FPS: #{Gosu.fps}", 5.5, 5.5, 10, 1,1, Gosu::Color::GRAY)
      @font.draw_text("FPS: #{Gosu.fps}", 5, 5, 10, 1,1, Gosu::Color::WHITE)
      @world_generator.draw_world
    end

    def update
      chunk_it
    end

    def chunk_it
      x = (mouse_x / (@world_generator.chunk_size * @world_generator.block_size)).floor
      y = (mouse_y / (@world_generator.chunk_size * @world_generator.block_size)).floor
      x = 0 if x < 0
      y = 0 if y < 0

      unless (@world_generator.chunks.exist?(x, y))
        # puts "cms> #{x}:#{y}"
        @world_generator.generate_chunk(x, y)
      end
    end

    def button_up(id)
      case id
      when Gosu::KbEscape
        close
      end
    end

    def needs_cursor?
      true
    end
  end
end