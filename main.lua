
	--- Main file
	-- Work in progress
	-- @copyright Xkeeper 2014
	--

	-- Version
	version		= "r5"


	--- LOVE Init
	function love.load()


		-- Seed a new random number set
		math.randomseed(os.time())

		-- Include required classes
		LCS			= require("classes.LCS")		-- Lua Class System
		Screen		= require("classes.Screen")		-- Game (contains all the other stuff)
		Game		= require("classes.Game")		-- Game (contains all the other stuff)
		Playfield	= require("classes.Playfield")	-- Playfield
		Piece		= require("classes.Piece")		-- Pieces
		Block		= require("classes.Block")		-- Blocks

		screens			= {

			default			= Screen:new(),
			introScreen		= require("classes.Screen.IntroScreen"):new(),
			titleScreen		= require("classes.Screen.TitleScreen"):new(),
			inGame			= require("classes.Screen.InGame"):new(),
			inGamePaused	= require("classes.Screen.InGamePaused"):new(),

			}

		currentScreen	= "introScreen";



		blockImage		= love.graphics.newImage("images/blocks.png")
		logoImage		= love.graphics.newImage("images/rustedlogic.png")
		background		= love.graphics.newImage("images/background.png")
		backgroundP		= love.graphics.newImage("images/background-playfield.png")


		local blockImageW	= blockImage:getWidth()
		local blockImageH	= blockImage:getHeight()

		local gameGridHeight, gameGridWidth	= 18, 18

		blockGraphics	= {
							Block:new({{16 * 1, 0}}, 16, 16, blockImageW, blockImageH, gameGridHeight, gameGridWidth),
							Block:new({{16 * 2, 0}}, 16, 16, blockImageW, blockImageH, gameGridHeight, gameGridWidth),
							Block:new({{16 * 3, 0}}, 16, 16, blockImageW, blockImageH, gameGridHeight, gameGridWidth),
							Block:new({{16 * 4, 0}}, 16, 16, blockImageW, blockImageH, gameGridHeight, gameGridWidth),

						}
		blockGraphics[0]	= Block:new({{0, 0}}, 16, 16, blockImageW, blockImageH, gameGridHeight, gameGridWidth)

		blockGraphics[-1]	= Block:new({
									{16 * 0, 16},
									{16 * 1, 16},
									{16 * 2, 16},
									{16 * 3, 16},
									},
									16, 16, blockImageW, blockImageH, gameGridHeight, gameGridWidth, .25 * (1/4)
									)

		blockGraphics[99]	= Block:new({
									{16 * 5, 0},
									{16 * 6, 0},
									{16 * 7, 0}
									}, 
									16, 16, blockImageW, blockImageH, gameGridHeight, gameGridWidth, .25 * (1/4)
									)

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
			big			= love.graphics.setNewFont(30),
			main		= love.graphics.setNewFont(10),
			numbers		= love.graphics.newImageFont("images/numberfont.png", "0123456789 .x"),
			bignumbers	= love.graphics.newImageFont("images/numberfont-2x.png", "0123456789 .x"),

			}

		sounds	= {
			clear		= love.audio.newSource("sounds/clear.wav", "static"),
			cycle		= love.audio.newSource("sounds/cycle.wav", "static"),
			drop		= love.audio.newSource("sounds/drop.wav", "static"),
			lock		= love.audio.newSource("sounds/lock.wav", "static"),
			move		= love.audio.newSource("sounds/move.wav", "static"),
			gravity		= love.audio.newSource("sounds/gravity.wav", "static"),
			magic		= love.audio.newSource("sounds/magicpiece.wav", "static"),
			levelup		= love.audio.newSource("sounds/levelup.wav", "static"),
			}




		gTimer			= 0
		pauseTimer		= false

		testPlayfield	= Playfield:new()

		testGame		= Game:new(testPlayfield, {1, 2, 3, 4})

		testScreen		= Screen:new()

		keysHeld		= {}

	end



	--- LOVE Drawing callback.
	function love.draw()

		screens[currentScreen]:draw()


	end



	--- LOVE Update callback.
	-- @param dt	Delta-time of update (in seconds)
	function love.update(dt)
		if not pauseTimer then
			gTimer	= gTimer + dt
		end

		screens[currentScreen]:update(dt)
		--testGame:update()
	end



	--- LOVE Keypress callback
	-- (mostly for debugging right now)
	-- @param key		Character of the key pressed
	-- @param isrepeat	If this is a repeat keypress (based on system options/timing)
	function love.keypressed(key, isrepeat)

		-- Mark this key as being down
		keysHeld[key]	= gTimer

		screens[currentScreen]:handleKeyPress(key, isrepeat)

	end


	--- LOVE Keyrelease callback
	-- (mostly for debugging right now)
	-- @param key		Character of the key released
	function love.keyreleased(key, isrepeat)

		-- Mark this key as being down
		keysHeld[key]	= nil

	end






	--- Changes to a new screen
	-- @param newScreen	Screen to change to
	function changeScreen(newScreen)

		if not screens[newScreen] then
			error("The requested screen '".. newScreen .."' doesn't exist")
		end

		if currentScreen.switchOut then
			currentScreen:switchOut()
		end
		currentScreen	= newScreen
		if currentScreen.switchIn then
			currentScreen:switchIn()
		end

	end




	--- Checks if given value is in range of other values
	-- @param val	Value to test
	-- @param min	Lower bound
	-- @param max	Upper bound
	function math.inrange(val, min, max)
		return val >= min and val <= max
	end



	function drawTestBackground()
		love.graphics.push()
		love.graphics.draw(background, 0, 0)
		love.graphics.pop()
	end

