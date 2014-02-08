
	-- Require Lua Class System
	LCS	= require("classes.LCS")

	-- Create class
	Screen	= LCS.class({ fadeInTime = .5, fadeOutTime = .5 })


	--- Callback for initializing a new instance
	function Screen:init()


	end


	--- Callback for updating this screen.
	-- @param dt Delta-time in seconds since last update
	function Screen:update(dt)


	end


	--- Callback for drawing this screen
	-- Should draw anything relevant in here
	function Screen:draw()
		love.graphics.print("Default screen", 300, 200)

	end

	--- Callback for handling keypresses.
	-- @param key Key pressed
	-- @param isRepeat If this is an auto-repeated keypress
	function Screen:handleKeyPress(key, isRepeat)

	end


	--- Callback for when this screen is switched in
	function Screen:switchIn()
	end

	--- Callback for when this screen is switched out
	function Screen:switchOut()
	end


	--- Fade in the screen.
	-- @param percent	Percent through fade animation
	function Screen:fadeIn(percent)

		local	b	= math.min(255, math.max(0, 255 - percent * 255))
		self:fadeOverlay(b)

	end


	--- Fade in the screen.
	-- @param percent	Percent through fade animation
	function Screen:fadeOut(percent)

		local	b	= math.min(255, math.max(0, percent * 255))
		self:fadeOverlay(b)

	end


	--- Draw a box covering the entire screen to fade it in/out
	-- @param alpha Alpha level (for color)
	function Screen:fadeOverlay(alpha)

		local r, g, b, a	= love.graphics.getColor()


		love.graphics.setColor(0, 0, 0, alpha)
		love.graphics.polygon("fill", {
			0,		0,
			640,	0,
			640,	480,
			0,		480,
			})

		love.graphics.setColor(r, g, b, a)

	end


	return Screen