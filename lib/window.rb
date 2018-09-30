class CubeWorld
  class Window < Gosu::Window
    def initialize
      super(Gosu.available_width/4*3, Gosu.available_height/4*3, fullscreen: false)
      self.caption = "CubeWorld - A Ruby Voxel Adventure"

      @world_generator = WorldGenerator.new
    end

    def draw
      @world_generator.draw_world
    end

    def update
      chunk_it
    end

    def chunk_it
      x = (mouse_x/(@world_generator.chunk_size*@world_generator.block_size)).round
      y = (mouse_y/(@world_generator.chunk_size*@world_generator.block_size)).round
      x = 0 if x < 0
      y = 0 if y < 0


      unless (@world_generator.chunks.exist?(x, y))
        puts "cms> #{x}:#{y}"
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