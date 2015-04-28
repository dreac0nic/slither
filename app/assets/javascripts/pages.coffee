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
		@previousDirection = @direction

		for i in [0...length]
			@segments.push(new Point(spawn_pos.x, spawn_pos.y))

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
		for segment in @segments
			context.beginPath()
			context.rect(segment.x*size, segment.y*size, size, size)
			context.closePath()
			context.fillStyle = "white"
			context.fill()

	update: (game) ->
		@direction = @lastDirection if @direction == this.oppositeDirection(@lastDirection)

		if false
			@alive = false
		else
			@lastDirection = @direction
			@segments.pop()
			@segments.unshift(this.head().add(this.nextPosition()))

class Game
	constructor: (@context, @width = 48, @height = 42, @size = 10) ->


$ ->
	context = document.getElementById("snake-canvas").getContext("2d")

	mySnake = new Snake(new Point(0, 0), 10)

	for i in [0...1000]
		directions = ["up", "down", "left", "right"]
		mySnake.direction = directions[Math.floor(Math.random()*4)]
		mySnake.update()

	context.beginPath()
	context.rect(0, 0, 420, 480)
	context.closePath()
	context.fillStyle = "black"
	context.fill()
	mySnake.draw(context)
