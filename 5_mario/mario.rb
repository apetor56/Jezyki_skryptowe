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

class Coin
  attr_accessor :x, :y, :width, :height, :image, :collected

  def initialize(x, y)
    @image = Image.new('coin.png', x: x, y: y, width: 25, height: 25, color: [1, 1, 1, 1.0])
    @x = @image.x
    @y = @image.y
    @width = @image.width
    @height = @image.height
    @collected = false
  end

  def draw
    @image.x = @x
    @image.y = @y
    @image.draw unless @collected
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

coins = [
  Coin.new(600, 350), Coin.new(850, 300), Coin.new(1600, 350),
  Coin.new(1850, 300), Coin.new(2150, 300), Coin.new(2450, 350)
]

key_states = { left: false, right: false, space: false }
game_over = false
game_won = false
score = 0
score_text = Text.new("Score: #{score}", x: 10, y: 10, size: 30, color: "yellow", font: "dpcomic.ttf")

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
    coins.each(&:draw)

    coins.each do |coin|
      unless coin.collected
        coin.draw
        if player.x + player.width > coin.x &&
           player.x < coin.x + coin.width &&
           player.y + player.height > coin.y &&
           player.y < coin.y + coin.height
          coin.x = -1000
          coin.y = -1000
          coin.collected = true
          score += 10
          score_text.text = "Score: #{score}"
        end
      end
    end

    if key_states[:left]
      player.direction = -1
      move_objects_right(floor_blocks)
      move_objects_right(spikes)
      move_objects_right([flag])
      move_objects_right(coins)
    elsif key_states[:right]
      player.direction = 1
      move_objects_left(floor_blocks)
      move_objects_left(spikes)
      move_objects_left([flag])
      move_objects_left(coins)
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
        Text.new("Game Over", x: 300, y: 250, size: 70, color: 'red', font: "dpcomic.ttf")
      end
    end

    if player.x + player.width > flag.x &&
       player.x < flag.x + flag.width &&
       player.y + player.height > flag.y &&
       player.y < flag.y + flag.height

      game_won = true
      Text.new("You Win!", x: 295, y: 200, size: 80, color: 'green', font: "dpcomic.ttf")
      Text.new("Score: #{score}", x: 330, y: 260, size: 50, color: 'yellow', font: "dpcomic.ttf")
    end

    if player.y > 600
      game_over = true
      Text.new("Game Over", x: 300, y: 250, size: 70, color: 'red', font: "dpcomic.ttf")
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

on :key_down do |event|
  if event.key == 'r' && ( game_over == true || game_won == true )
    close
    system('ruby mario.rb')
  end
end

show
