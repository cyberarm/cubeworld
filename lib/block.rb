class CubeWorld
  class Block
    AIR   = 0
    WATER = 1
    SAND  = 2
    GRASS = 3
    DIRT  = 4
    WOOD  = 5
    LEAF  = 6

    def self.from_id(id)
      case id
      when AIR
        {color: Gosu::Color::BLACK}
      when WATER
        {color: Gosu::Color::BLUE}
      when SAND
        {color: Gosu::Color::GRAY}
      when GRASS
        {color: Gosu::Color::GREEN}
      when DIRT
        {color: Gosu::Color.rgb(127, 64, 0)}
      when WOOD
        {color: Gosu::Color::PINK}
      when LEAF
        {color: Gosu::Color::RED}
      else
        raise "Unknown Block ID: #{id}"
      end
    end
  end
end