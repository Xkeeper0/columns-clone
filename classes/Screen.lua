
	-- Require Lua Class System
	LCS	= require("classes.LCS")

	-- Create class
	Screen	= LCS.class()


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



	return Screen