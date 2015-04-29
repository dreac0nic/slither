# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Point
	constructor: (@x = 0, @y = 0) ->
		if typeof @x is "object"
			other = @x

			@x = other.x
			@y = other.y

	equals: (other) ->
		@x == other.x and @y == other.y

	add: (other) ->
		next = new Point(@x, @y)
		next.x += other.x
		next.y += other.y

		next

	to_s: () ->
		"(" + @x + ", " + @y + ")"

class Snake
	constructor: (spawn_pos, length = 15, @direction = "right") ->
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

	grow: () ->
		@segments.push(new Point(this.tail()))

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

		this.head().add(next)

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

	update: () ->
		@direction = @previous_direction if @direction == this.oppositeDirection(@previous_direction)

		# Test for death!
		if this.occupies(this.nextPosition())
			@alive = false

		# Move the snake if it's still alive!
		if @alive
			@previous_direction = @direction
			@old_segment = @segments.pop()
			@segments.unshift(this.nextPosition())

class Game
	constructor: (canvas, @width = 42, @height = 48, @size = 10, @dot_quota = 1) ->
		@input_direction = "right"

		@context = canvas.getContext("2d")
		@first_draw = true
		@state = "menu"

		@score = 0
		@collected = 0
		@multipliers = [1, 1]

		@dots = []
		@snake = new Snake(new Point(Math.floor(@width/2), Math.floor(@height/2)))

	tick: (context) ->
		this.update()
		this.draw(context)

	reset: () ->
		@score = 0
		@collected = 0
		@multipliers = [1, 1]

		@collect_time = -1;

		@last_time = -1

		@snake = new Snake(new Point(Math.floor(@width/2), Math.floor(@height/2)))
		@dots = []

		@first_draw = true

	bumpMultiplier: () ->
		size = @multipliers.length
		first = @multipliers[size - 1]
		second = @multipliers[size - 2]

		@multipliers.push(first + second)

	decayMultiplier: () ->
		@multipliers.pop()


	addScore: (points) ->
		@score += Math.floor(@multipliers[@multipliers.length - 1]*points)

	update: () ->
		switch @state
			when "menu" then console.log("MENU")
			when "game"
				@state = "gameover" if not @snake.alive
				@dots.push(new Point(Math.floor(Math.random()*@width), Math.floor(Math.random()*@height))) if @dots.length < @dot_quota

				for dot in @dots
					if @snake.occupies dot
						@snake.grow()
						@dots.splice(@dots.indexOf(dot), 1)

						# Add to score
						@collected += 1

						this.addScore(250*@collected)
						this.bumpMultiplier()

				# Add score over time.
				if @last_time > 0
					new_time = (new Date()).getTime()
					this.addScore((new_time - @last_time)/25)

					@last_time = new_time
				else
					@last_time = (new Date()).getTime()

				document.getElementById("score").innerHTML = "SCORE: " + @score

				@snake.direction = @input_direction
				@snake.update()

				# Make sure the snake has not left the arena
				if @snake.head().x < 0 or @snake.head().y < 0 or @snake.head().x >= @width or @snake.head().y >= @height
					@snake.alive = false
			when "gameover" then console.log("GAME OVER")

	draw: (context) ->
		context.fillStyle = "black"
		context.fillRect(0, 0, @width*@size, @height*@size) if @first_draw

		switch @state
			when "game"
				# Draw the collectables!
				context.fillStyle = "red"
				for dot in @dots
					context.fillRect(dot.x*@size, dot.y*@size, @size, @size)

				# Draw the snake!
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
