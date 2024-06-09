require 'ruby2d'

set title: "Mario"
set width: 800
set height: 600

class Background
  def initialize(image_path)
    @image = Image.new(image_path, x: 0, y: 0, width: 800, height: 600)
  end

  def draw
    @image.draw
  end
end

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

class Spike
  attr_accessor :x, :y, :width, :height, :image

  def initialize(x, y)
    @image = Image.new('spikes.png', x: x, y: y, width: 25, height: 25, color: [1, 1, 1, 1.0])
    @x = @image.x
    @y = @image.y
    @width = @image.width
    @height = @image.height
  end

  def draw
    @image.x = @x
    @image.y = @y
    @image.draw
  end
end

class Flag
  attr_accessor :x, :y, :width, :height, :image

  def initialize(x, y)
    @image = Image.new('flag.png', x: x, y: y, width: 75, height: 75, color: [1, 1, 1, 1.0])
    @x = @image.x
    @y = @image.y
    @width = @image.width
    @height = @image.height
  end

  def draw
    @image.x = @x
    @image.y = @y
    @image.draw
  end
end

class FloorBlock
  attr_accessor :x, :y, :width, :height, :image

  def initialize(x, y, width, height, texture_path)
    @x = x
    @y = y
    @width = width
    @height = height
    @image = Image.new(texture_path, x: x, y: y, width: width, height: height)
  end

  def draw
    @image.x = @x
    @image.y = @y
    @image.draw
  end
end

background = Background.new('sky.png')

player = Player.new

floor_blocks = [
  FloorBlock.new(-300, 0, 500, 800, 'grass.png'),
  FloorBlock.new(300, 400, 400, 500, 'grass.png'),
  FloorBlock.new(900, 350, 200, 500, 'grass.png'),
  FloorBlock.new(1100, 500, 300, 500, 'grass.png'), 
  FloorBlock.new(1550, 400, 200, 500, 'grass.png'),
  FloorBlock.new(1950, 350, 200, 500, 'grass.png'), 
  FloorBlock.new(2400, 500, 400, 500, 'grass.png')
]

spikes = [
  Spike.new(450, 375), Spike.new(475, 375), Spike.new(500, 375),
  Spike.new(975, 325), Spike.new(1000, 325), 
  Spike.new(1100, 475), Spike.new(1125, 475), Spike.new(1200, 475), Spike.new(1300, 475),
  Spike.new(2050, 325), Spike.new(2075, 325)
]

flag = Flag.new(2575, 425)

key_states = { left: false, right: false, space: false }
game_over = false
game_won = false

def move_objects_left(objects)
  objects.each { |obj| obj.x -= 5 }
end

def move_objects_right(objects)
  objects.each { |obj| obj.x += 5 }
end

update do
  unless game_over || game_won
    background.draw

    player.update
    player.draw

    floor_blocks.each(&:draw)
    spikes.each(&:draw)
    flag.draw

    if key_states[:left]
      player.direction = -1
      move_objects_right(floor_blocks)
      move_objects_right(spikes)
      move_objects_right([flag])
    elsif key_states[:right]
      player.direction = 1
      move_objects_left(floor_blocks)
      move_objects_left(spikes)
      move_objects_left([flag])
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

    spikes.each do |spike|
      if player.x + player.width > spike.x &&
         player.x < spike.x + spike.width &&
         player.y + player.height > spike.y &&
         player.y < spike.y + spike.height

        game_over = true
        Text.new("Game Over", x: 300, y: 250, size: 50, color: 'red')
      end
    end

    if player.x + player.width > flag.x &&
       player.x < flag.x + flag.width &&
       player.y + player.height > flag.y &&
       player.y < flag.y + flag.height

      game_won = true
      Text.new("You Win!", x: 300, y: 250, size: 50, color: 'green')
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
