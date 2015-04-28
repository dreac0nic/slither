# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Point
	constructor: (@x = 0, @y = 0) ->

	equals: (other) ->
		@x == other.x and @y == other.y

	add: (other) ->
		next = new Point(@x, @y)
		next.x += other.x
		next.y += other.y

		next

class Snake
	constructor: (spawn_pos, length = 5, @direction = "right") ->
		@segments = []
		@alive = true
		@previous_direction = @direction

		for i in [0...length]
			@segments.push(new Point(spawn_pos.x, spawn_pos.y))

		@old_segment = this.tail()

	head: () ->
		@segments[0]

	tail: () ->
		@tail[@segments.length - 1]

	occupies: (location) ->
		result = false

		for segment in @segments
			if segment.equals(location)
				result = true
				break

		result

	nextPosition: () ->
		next = new Point(0, 0)

		switch @direction
			when "up" then next.y = 1
			when "down" then next.y = -1
			when "right" then next.x = 1
			when "left" then next.x = -1

		next

	oppositeDirection: (targetDirection) ->
		switch targetDirection
			when "up" then "down"
			when "down" then "up"
			when "left" then "right"
			when "right" then "left"

	draw: (context, size = 10) ->
		context.fillStyle = "black"
		context.fillRect(@old_segment.x*size, @old_segment.y*size, size, size)

		for segment in @segments
			context.fillStyle = "white"
			context.fillRect(segment.x*size, segment.y*size, size, size)

	update: (game) ->
		@direction = @previous_direction if @direction == this.oppositeDirection(@previous_direction)

		if false
			@alive = false
		else
			@previous_direction = @direction
			@old_segment = @segments.pop()
			@segments.unshift(this.head().add(this.nextPosition()))

class Game
	constructor: (canvas, @width = 42, @height = 48, @size = 10) ->
		@input_direction = "right"

		@context = canvas.getContext("2d")
		@first_draw = true
		@state = "menu"

		@dots = []
		@snake = new Snake(new Point(Math.floor(@width/2), Math.floor(@height/2)))

		@context.fillStyle = "black"
		@context.fillRect(0, 0, @width*@size, @height*@size)

	tick: (context) ->
		console.log("TICK")

		this.update()
		this.draw(context)

	update: () ->
		switch @state
			when "menu" then console.log("MENU")
			when "game"
				@snake.direction = @input_direction
				@snake.update(this)
			when "gameover" then console.log("GAME OVER")

	draw: (context) ->
		context.fillStyle = "black"
		context.fillRect(0, 0, @width*@size, @height*@size) if @first_draw

		switch @state
			when "game"
				@snake.draw(context)

		@first_draw = false


$ ->
	canvas = document.getElementById("snake-canvas")
	context = canvas.getContext("2d") if canvas?

	game_instance = new Game(canvas)
	game_instance.state = "game"

	document.onkeydown = (data) ->
		key_code = data.keyCode

		switch key_code
			when 40 then game_instance.input_direction = "up"
			when 38 then game_instance.input_direction = "down"
			when 37 then game_instance.input_direction = "left"
			when 39 then game_instance.input_direction = "right"

	setInterval () ->
		game_instance.tick(context)
	, 40
