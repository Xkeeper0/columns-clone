
	--- Main file
	-- Work in progress
	-- @copyright Xkeeper 2014
	--


	--- LOVE Init
	function love.load()

		-- Set includes to check classes/?.lua
		package.path	= package.path .. ";classes/?.lua"

		-- Include required classes
		LCS			= require("LCS")		-- Lua Class System
		Playfield	= require("Playfield")	-- Playfield
		Piece		= require("Piece")		-- Pieces

		testPlayfield	= Playfield:new()
		testPiece		= Piece:new({1, 2, 3, 4, 5})
		lastKey			= ""

	end



	--- LOVE Drawing callback.
	function love.draw()

		love.graphics.print(tostring(testPlayfield), 100, 100)
		love.graphics.print(tostring(testPiece), 400, 100)
		love.graphics.print(tostring(lastKey), 400, 200)


	end


	--- LOVE Update callback.
	-- @param dt	Delta-time of update (in seconds)
	function love.update(dt)


	end



	--- LOVE Keypress callback
	-- (mostly for debugging right now)
	-- @param key		Character of the key pressed
	-- @param isrepeat	If this is a repeat keypress (based on system options/timing)
	function love.keypressed(key, isrepeat)
		lastKey	= key

	end