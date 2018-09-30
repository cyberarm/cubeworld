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
    end

    def button_up(id)
      case id
      when Gosu::KbEscape
        close
      end
    end
  end
end