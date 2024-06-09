require 'ruby2d'

set title: "Mario"
set width: 800
set height: 600
set background: [0.1, 0.1, 1.0, 1.0]

class Player
  attr_accessor :x, :y, :width, :height, :velocity_y, :on_ground, :image

  def initialize
    @image = Image.new('mario.png', x: 375, y: 450, width: 50, height: 50, color: [1, 1, 1, 1.0])
    @x = @image.x
    @y = @image.y
    @width = @image.width
    @height = @image.height
    @velocity_y = 0
    @on_ground = true
    @direction = 1
  end

  def draw
    @image.x = @x
    @image.y = @y
    @image.width = @width * @direction
  end

  def jump
    if @on_ground
      @velocity_y = -12
      @on_ground = false
    end
  end

  def update
    @velocity_y += 0.5
    @y += @velocity_y
  end

  def direction=(dir)
    @direction = dir
  end
end

player = Player.new

floor_blocks = [
  Rectangle.new(x: -300, y: 0, width: 500, height: 800, color: [0.1, 0.8, 0.2, 1.0]),
  Rectangle.new(x: 300, y: 400, width: 400, height: 500, color: [0.1, 0.8, 0.2, 1.0]),
  Rectangle.new(x: 900, y: 350, width: 200, height: 500, color: [0.1, 0.8, 0.2, 1.0]),
  Rectangle.new(x: 1100, y: 500, width: 300, height: 500, color: [0.1, 0.8, 0.2, 1.0]), 
  Rectangle.new(x: 1550, y: 400, width: 200, height: 500, color: [0.1, 0.8, 0.2, 1.0]),
  Rectangle.new(x: 1950, y: 350, width: 200, height: 500, color: [0.1, 0.8, 0.2, 1.0]), 
  Rectangle.new(x: 2400, y: 500, width: 350, height: 500, color: [0.1, 0.8, 0.2, 1.0])
]

key_states = { left: false, right: false, space: false }
game_over = false

def move_objects_left(objects)
  objects.each { |obj| obj.x -= 5 }
end

def move_objects_right(objects)
  objects.each { |obj| obj.x += 5 }
end

def center_camera(player)
  if player.x > (get(:width) / 2) && player.x < (800 - get(:width) / 2)
    set viewport: [player.x - (get(:width) / 2), 0, get(:width), get(:height)]
  elsif player.x >= (800 - get(:width) / 2)
    set viewport: [800 - get(:width), 0, get(:width), get(:height)]
  else
    set viewport: [0, 0, get(:width), get(:height)]
  end
end

update do
  unless game_over
    player.update
    player.draw

    if key_states[:left]
      player.direction = -1
      move_objects_right(floor_blocks)
    elsif key_states[:right]
      player.direction = 1
      move_objects_left(floor_blocks)
    end

    player.on_ground = false

    floor_blocks.each do |block|
      if player.x + player.width > block.x &&
         player.x < block.x + block.width &&
         player.y + player.height >= block.y &&
         player.y + player.height <= block.y + block.height

        player.y = block.y - player.height
        player.velocity_y = 0
        player.on_ground = true
      end
    end

    if player.y > 600
      game_over = true
      Text.new("Game Over", x: 300, y: 250, size: 50, color: 'red')
    end
  end
end

on :key_held do |event|
  case event.key
  when 'left'
    key_states[:left] = true
  when 'right'
    key_states[:right] = true
  when 'space'
    if !key_states[:space]
      player.jump
      key_states[:space] = true
    end
  end
end

on :key_up do |event|
  case event.key
  when 'left'
    key_states[:left] = false
  when 'right'
    key_states[:right] = false
  when 'space'
    key_states[:space] = false
  end
end

show
