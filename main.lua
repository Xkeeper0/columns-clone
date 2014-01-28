
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
		Playfield	= require("classes.Playfield")	-- Playfield
		Piece		= require("classes.Piece")		-- Pieces

		testPlayfield	= Playfield:new()
		testPiece		= Piece:new({1, 2, 3, 4})
		lastKey			= ""

		testPieceX		= 3
		testPieceY		= 1

		blockColors		= {	
							{ 255,   0,   0 },
							{ 255, 255,   0 },
							{  80, 255,  80 },
							{ 100, 100, 255 },
							{ 255,   0, 255 }

						}
		blockColors[0]	= { 40, 40, 40}

		clearColors		= {	
							{ 255,  80,  80 },
							{ 255, 255,   0 },
							{  80, 255,  80 },
							{  80, 255, 255 },
							{  80,  80, 255 },
							{ 255,  80, 255 },
							{ 255, 180, 180 },
							{ 255, 255, 255 },
						}



		fonts	= {
			main		= love.graphics.setNewFont(10),
			numbers		= love.graphics.newImageFont("images/numberfont.png", "0123456789 .x");
			bignumbers	= love.graphics.newImageFont("images/numberfont-2x.png", "0123456789 .x");

			}

		sounds	= {
			clear		= love.audio.newSource("sounds/clear.wav", "static"),
			drop		= love.audio.newSource("sounds/drop.wav", "static"),
			gravity		= love.audio.newSource("sounds/gravity.wav", "static")
			}


		wasClear		= false
		clearPoints		= 0
		totalScore		= 0

		gTimer	= 0

	end



	--- LOVE Drawing callback.
	function love.draw()

		love.graphics.setFont(fonts.numbers)

		testPlayfield:draw(100, 100)
		testPiece:draw(100, 100, testPieceX, testPieceY)

		love.graphics.setColor(150, 150, 150)

		if wasClear then
			love.graphics.setFont(fonts.numbers)
			love.graphics.printf(string.format("%d\nx%2d", clearPoints, wasClear or 0), 300, 170, 99, "right")
			love.graphics.setColor(clearColors[math.min(#clearColors, wasClear)])
			love.graphics.setFont(fonts.bignumbers)
			love.graphics.printf(string.format("%d", clearPoints * (wasClear or 0)), 300, 190, 100, "right")
		end

		love.graphics.setFont(fonts.bignumbers)
		love.graphics.setColor(255, 255, 255)
		love.graphics.printf(string.format("%d", totalScore), 300, 220, 100, "right")

		love.graphics.setFont(fonts.numbers)
		love.graphics.printf(string.format("%.2f", gTimer), 300, 300, 100, "right")

		love.graphics.setFont(fonts.main)


		love.graphics.print("arrow keys: move\nspace: drop\nx: cycle colors\n\nclears/gravity is on a timer for now\n\nenjoy", 500, 150)


	end



	--- LOVE Update callback.
	-- @param dt	Delta-time of update (in seconds)
	function love.update(dt)
		if math.floor((gTimer + dt) * 2) > math.floor(gTimer * 2) then
			if math.fmod(gTimer * 2, 2) < 1 then
				local clears	= testPlayfield:checkForClears()
				if clears then
					testPlayfield:clearClears(clears)
					wasClear	= wasClear and (wasClear + 1) or 1
					clearPoints	= 100 * #clears
					sounds.clear:stop()
					sounds.clear:setPitch(1 + math.pow(wasClear, 1.025))
					sounds.clear:play()
				else
					wasClear	= false
				end
			elseif wasClear then
				totalScore	= totalScore + clearPoints * wasClear
				testPlayfield:doGravity()
				sounds.gravity:stop()
				sounds.gravity:play()
			end
		end

		gTimer	= gTimer + dt


	end



	--- LOVE Keypress callback
	-- (mostly for debugging right now)
	-- @param key		Character of the key pressed
	-- @param isrepeat	If this is a repeat keypress (based on system options/timing)
	function love.keypressed(key, isrepeat)
		lastKey	= key

		if key == "left" then
			if testPlayfield:canPlacePiece(testPiece, testPieceX - 1, testPieceY) then
				testPieceX	= testPieceX - 1
			end
		end
		if key == "right" then
			if testPlayfield:canPlacePiece(testPiece, testPieceX + 1, testPieceY) then
				testPieceX	= testPieceX + 1
			end
		end
		if key == "up" then
			if testPlayfield:canPlacePiece(testPiece, testPieceX, testPieceY - 1) then
				testPieceY	= testPieceY - 1
			end
		end
		if key == "down" then
			if testPlayfield:canPlacePiece(testPiece, testPieceX , testPieceY + 1) then
				testPieceY	= testPieceY + 1
			end
		end


		if key == "x" then
			testPiece:cycleBlocks()
		end

		if key == " " then
			testPlayfield:placePiece(testPiece, testPieceX, testPieceY)
			testPlayfield:doGravity()

			testPiece	= Piece:new({1, 2, 3, 4})
			testPieceX	= 3
			testPieceY	= 1

		end



	end