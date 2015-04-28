# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Point
	constructor: (@x = 0, @y = 0) ->

	equals: (other) ->
		@x == other.x and @y == other.y

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
