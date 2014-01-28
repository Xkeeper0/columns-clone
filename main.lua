
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

		testPieceX		= 3
		testPieceY		= 1

		blockColors		= {	
							{ 255,   0,   0 },
							{ 255, 255,   0 },
							{  80, 255,  80 },
							{ 100, 100, 255 },
							{ 255,   0, 255 }

						}

		blockColors[0]	= { 20, 20, 20}


	end



	--- LOVE Drawing callback.
	function love.draw()

		testPlayfield:draw(100, 100)
		testPiece:draw(100, 100, testPieceX, testPieceY)

		-- love.graphics.print(tostring(testPlayfield), 100, 100)
		-- love.graphics.print(tostring(testPiece), 400, 100)
		-- love.graphics.print(tostring(lastKey), 400, 200)

		love.graphics.setColor(255, 255, 255)
		love.graphics.print("arrow keys: move\nspace: drop\n\nclears/gravity is on a timer for now\n\nenjoy", 400, 150)

	end



	gTimer	= 0
	--- LOVE Update callback.
	-- @param dt	Delta-time of update (in seconds)
	function love.update(dt)
		if math.floor(gTimer + dt * 2) > math.floor(gTimer) then
			if math.fmod(gTimer, 2) < 1 then
				local clears	= testPlayfield:checkForClears()
				if clears then
					testPlayfield:clearClears(clears)
				end
			else
				testPlayfield:doGravity()
			end
		end

		gTimer	= gTimer + dt * 2


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
			-- testPiece:cycleBlocks()
		end

		if key == " " then
			testPlayfield:placePiece(testPiece, testPieceX, testPieceY)
			testPlayfield:doGravity()

			testPiece	= Piece:new({1, 2, 3, 4})
			testPieceX	= 3
			testPieceY	= 1

		end


	end