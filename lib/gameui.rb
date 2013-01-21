require "pp"
require "chingu"

class GameUI < Chingu::GameState
  include Chingu
  def initialize(options={})
    super
    options[:title] ||= "Game Title"
    options[:font]  ||= "./lib/fonts/Hobby-of-night.ttf"
    @font=options[:font]
    @elements = []
    @rects    = []
    @tooltip  = Chingu::Text.new("", x: 1, y: 80, size: 50, font: @font)
    @released_left_mouse_button = false

    @elements.push({
      object: Chingu::Text.new("#{options[:title]}",
      x: 90,
      y: 20,
      size: 70,
      font: @font)
      })

    on_input([:left_mouse_button], :released_left_mouse_button)
  end

  def push_game_state(constant, options={})
    super
    @rects    = []
    @elements = []
  end

  def draw
    super
    @elements.each do |element|
      element[:object].draw
    end

    @rects.each do |rect|
      fill_rect([rect[:x],rect[:y],rect[:width],rect[:height]],rect[:color])
    end
    @tooltip.draw
  end

  def update
    super
    process_ui
    @rects.each do |rect|
      if $window.mouse_x.between?(rect[:x],rect[:x]+rect[:width]) && $window.mouse_y.between?(rect[:y],rect[:y]+rect[:height])
        rect[:color]=rect[:hover_color]
        @tooltip.text = rect[:tooltip].to_s if defined?(rect[:tooltip])
        @tooltip.y    = rect[:y]+10
        if @released_left_mouse_button && $window.button_down?(Gosu::MsLeft)
          sleep(0.1)
          rect[:block].call
        end
      else
        rect[:color]=rect[:old_color]
      end
    end
    @tooltip.text = "" unless show_tooltip?
    @released_left_mouse_button = false
  end

  def button(text,options={}, &block)
    @get_available_y = 100
    unless @rects.nil?
      @rects.each do |rect|
        @get_available_y = rect[:y]+81
        if @get_available_y > $window.height
          warn "--WARNING: Button with text: \"#{text}\", is not visible."
        end
      end
    end

    options[:color]       ||= Gosu::Color.rgba(255,120,0,255)
    options[:hover_color] ||= Gosu::Color.rgba(255,80,0,255)
    options[:x]           ||= 100
    options[:y]           ||= @get_available_y
    @elements.push(
      text={
        object: Chingu::Text.new("#{text}", x: options[:x], y: options[:y], size: 50, font: @font)
      }
    )
    
    @rects.push(
      {
        x: options[:x]-10,
        y: options[:y]-10,
        width: text[:object].width+20,
        height: text[:object].height+20,
        color: options[:color],
        old_color: options[:color],
        hover_color: options[:hover_color],
        block: block,
        tooltip: options[:tooltip]
      }
    )
  end

  def process_ui
    @big = nil
    @rects.each do |rect|
      unless @big
        @big = rect
        # p true
      end

      if @big[:width] < rect[:width]
        @big = rect
      end
    end

    @tooltip.x = @big[:width]+120

    @rects.each do |rect|
      rect[:width]=@big[:width]
    end
  end

  def show_tooltip?
    show = false
    @rects.each do |rect|
      if rect[:color] == rect[:hover_color]
        show = true
      end
    end

    return show
  end

  def released_left_mouse_button
    @released_left_mouse_button = true
  end
end