require "time"
require "securerandom"

require "gosu"
require "perlin"

require_relative "lib/window"
require_relative "lib/array_2d"
require_relative "lib/block"
require_relative "lib/world_generator"

CubeWorld::Window.new.show