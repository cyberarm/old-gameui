require "chingu"
require_relative "lib/gameui"

class Test < Chingu::Window
  def initialize
    super(1280,720,false)
    # super(1920,1080,true)
    $title = "GameUI"
    $window.caption = "GameUI"
    push_game_state(TestUI)
  end

  def needs_cursor?
    true
  end
end

class TestUI < GUI
  def initialize(options={})
    options[:title]="#{$title}"
    super
    button("Singleplayer", tooltip: "Start Playing Campaign\nResume On: Misson 7, Checkpoint 3.") do
      push_game_state(SoloUI)
    end

    button("Multiplayer", tooltip: "Play Online Against Other Players\nCurrent Rank: Recruit, Need 14 More Kills To Level Up") do
      push_game_state(MultiplayerUI)
    end

    button("Options", tooltip: "Configure Various Settings\nResolution: #{$window.width}x#{$window.height}, Fullscreen: #{$window.fullscreen?}") do
      # push_game_state(MultiplayerUI)
    end

    button("Exit", tooltip: "Quit to Windows") do
      exit
    end
  end
end

class SoloUI < GUI
  def initialize(options={})
    options[:title]="Singleplayer"
    super
    button("Back", tooltip: "Main Menu") do
      push_game_state(TestUI)
    end
  end
end

class MultiplayerUI < GUI
  def initialize(options={})
    options[:title]="Multiplayer"
    super
    button("Login", tooltip: "Login To Play Online") do
      push_game_state(TestUI)
    end
    button("Back", tooltip: "Main Menu") do
      push_game_state(TestUI)
    end
  end
end

Test.new.show