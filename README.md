# GameUI

A simple game menu.

# Usage Example
``` ruby
require "chingu"
require_relative "lib/gameui"

class GameWindow < Chingu::Window
  def initialize
    super(1280,720,false)
    push_game_state(GameMenu)
  end
end

class GameMenu < GameUI
  def initialize(options={})
    options[:title] = "GameUI" # Set menu header
    super
    button("Play", tooltip: "play the game") do
      puts "Write this yourself"
    end
  end
end

GameWindow.new.show
```
