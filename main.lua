
	--- Main file
	-- Work in progress
	-- @copyright Xkeeper 2014
	--


	--- LOVE Init
	function love.load()

		-- Set includes to check classes/?.lua
		--package.path	= package.path .. ";classes/?.lua"

		-- Include required classes
		LCS			= require("classes.LCS")		-- Lua Class System
		Game		= require("classes.Game")		-- Game (contains all the other stuff)
		Playfield	= require("classes.Playfield")	-- Playfield
		Piece		= require("classes.Piece")		-- Pieces


		blockColors		= {	
							{ 255,   0,   0 },
							{ 255, 255,   0 },
							{  80, 255,  80 },
							{ 100, 100, 255 },
							{ 255,   0, 255 }

						}
		blockColors[0]	= { 40, 40, 40}

		clearColors		= {	
							{ 120, 120, 255 },
							{ 180, 120, 240 },
							{ 220, 120, 220 },
							{ 240, 120, 180 },
							{ 255, 120, 120 },
							{ 240, 180, 120 },
							{ 220, 220, 120 },
							{ 180, 240, 120 },
							{ 120, 255, 120 },
							{ 120, 240, 180 },
							{ 120, 220, 220 },
							{ 120, 180, 240 },
							{ 150, 180, 255 },
							{ 200, 150, 240 },
							{ 240, 175, 200 },
							{ 255, 200, 240 },
							{ 255, 240, 240 },
							{ 255, 255, 255 },
						}



		fonts	= {
			main		= love.graphics.setNewFont(10),
			numbers		= love.graphics.newImageFont("images/numberfont.png", "0123456789 .x");
			bignumbers	= love.graphics.newImageFont("images/numberfont-2x.png", "0123456789 .x");

			}

		sounds	= {
			clear		= love.audio.newSource("sounds/clear.wav", "static"),
			cycle		= love.audio.newSource("sounds/cycle.wav", "static"),
			drop		= love.audio.newSource("sounds/drop.wav", "static"),
			move		= love.audio.newSource("sounds/move.wav", "static"),
			gravity		= love.audio.newSource("sounds/gravity.wav", "static")
			}




		gTimer	= 0

		testPlayfield	= Playfield:new()

		testGame		= Game:new(testPlayfield, {1, 2, 3, 4})

	end



	--- LOVE Drawing callback.
	function love.draw()

		testGame:draw(100, 100)
		--testGame:showGameState()

	end



	--- LOVE Update callback.
	-- @param dt	Delta-time of update (in seconds)
	function love.update(dt)
		gTimer	= gTimer + dt

		testGame:update()
	end



	--- LOVE Keypress callback
	-- (mostly for debugging right now)
	-- @param key		Character of the key pressed
	-- @param isrepeat	If this is a repeat keypress (based on system options/timing)
	function love.keypressed(key, isrepeat)


		keytable	= {
			up		= "harddrop",
			left	= "left",
			right	= "right",
			down	= "down",
			x		= "cycle"
			}

		if keytable[key] then
			testGame:movePiece(keytable[key])
		end

	end