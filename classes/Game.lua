
	-- Require Lua Class System
	LCS	= require("classes.LCS")

	-- Create class
	Game	= LCS.class()


	-- "Local variables"
	-- (i.e. 'protected')

	-- Score variables
	local currentScore			= 0			-- (real) current score
	local displayScore			= 0			-- in case I feel like making a fancy rolling counter
	local currentChain			= false		-- Current chain value (false if no chain)
	local clearScore			= 0			-- Points for the most recent clear

	local clearTotal			= 0			-- Total pieces cleared (for later)
	local currentLevel			= 0			-- Current game level




	-- Our current and next pieces for playing
	local currentPiece			= false
	local currentPiecePosition	= { x = 3, y = 1 }
	local nextPiece				= false
	local defaultPieceX			= 3
	local defaultPieceY			= 1

	local playfield				= false
	local blockTypes			= {1, 2, 3, 4}

	local clears				= false

	-- Current state we're in. Function pointer to what gets run?
	local gameState				= false
	-- Are we handling player input right now?
	local playerInput			= false

	-- Time when we went into this gamestate (used for timing)
	local gameStateTime	= 0

	--- Initialize a game
	-- What should this even do
	function Game:init(newPlayfield, blocks)

		-- Take in the playfield
		playfield			= newPlayfield
		blockTypes			= blocks and blocks or blockTypes

		-- Set the starting piece position to halfway into the field
		-- (Biased towards the left in the case of a tie)
		defaultPieceX		= math.floor(playfield.w / 2)

		-- Build two fancy new pieces for playing
		currentPiece		= Piece:new(blockTypes)
		nextPiece			= Piece:new(blockTypes)

		-- Put the piece where it should go
		currentPiecePosition.x	= defaultPieceX

		-- Initalize the game state
		gameState			= "pieceInPlay"
		gameStateTime		= gTimer

		playerInput			= true
	end


	function Game:getGameStateTime()
		return gTimer - gameStateTime

	end


	function Game.pieceInPlay(self, firstRun)
		playerInput	= true

		-- Gravity here?
		-- Otherwise do nothing of value because derp.

	end



	function Game.afterPiece(self, firstRun)
		
		if firstRun then
			playerInput	= false

			-- Check for clears?
			clears	= playfield:checkForClears()
			if clears then
				currentChain	= currentChain and (currentChain + 1) or 1
				clearPoints		= 100 * #clears * (currentLevel + 1)
			else
				currentChain	= false
				-- Skip right to the after-gravity phase
				self:update('beforeNextPiece')
			end

		else

			-- Delay for a bit and/or animate?
			if self:getGameStateTime() > 0.25 then
				self:update('doClears')
			end

		end


	end


	function Game.doClears(self, firstRun)
		if firstRun then
			playfield:clearClears(clears)
			sounds.clear:stop()
			sounds.clear:setPitch(1 + math.pow(currentChain, 1.025))
			sounds.clear:play()		else
		end

		-- Delay for a bit and/or animate?
		if self:getGameStateTime() > 0.25 then
			self:update('doGravity')
		end			
	end


	function Game.doGravity(self, firstRun)
		if firstRun then
			currentScore	= currentScore + clearPoints * currentChain
			testPlayfield:doGravity()
			sounds.gravity:stop()
			sounds.gravity:play()
		else
			
			-- Go back and check if there are more clears.
			if self:getGameStateTime() > 0.25 then
				self:update('afterPiece')
			end			
		end
	end


	function Game.beforeNextPiece(self, firstRun)

		-- Delay for a while
		if self:getGameStateTime() > .1 then
			self:update('nextPiece')
		end

	end


	function Game.nextPiece(self, firstRun)
		currentPiece			= nextPiece
		currentPiecePosition	= { x = defaultPieceX, y = defaultPieceY }
		nextPiece				= Piece:new(blockTypes)
		self:update('pieceInPlay')
	end



	local gameStates	= {

		pieceInPlay		= Game.pieceInPlay,
		afterPiece		= Game.afterPiece,
		doClears		= Game.doClears,
		doGravity		= Game.doGravity,
		beforeNextPiece	= Game.beforeNextPiece,
		nextPiece		= Game.nextPiece,

	}



	--- test
	function Game:update(newState)

		local firstRun		= false

		if newState then
			gameState		= newState
			gameStateTime	= gTimer
			firstRun		= true
		end

		-- Might need self added here???
		gameStates[gameState](self, firstRun and true or false)


		-- Something to do with game states here

	end



	---
	function Game:movePiece(direction)

		if not playerInput then
			return
		end

		if direction == "cycle" then
			sounds.cycle:stop()
			sounds.cycle:play()

			currentPiece:cycleBlocks()

		elseif direction == "left" then
			if playfield:canPlacePiece(currentPiece, currentPiecePosition.x - 1, currentPiecePosition.y) then
				sounds.move:stop()
				sounds.move:play()
				currentPiecePosition.x	= currentPiecePosition.x - 1
			end
		elseif direction == "right" then

			if playfield:canPlacePiece(currentPiece, currentPiecePosition.x + 1, currentPiecePosition.y) then
				sounds.move:stop()
				sounds.move:play()
				currentPiecePosition.x	= currentPiecePosition.x + 1
			end

		elseif direction == "down" then
			if playfield:canPlacePiece(currentPiece, currentPiecePosition.x , currentPiecePosition.y + 1) then
				testPieceY	= testPieceY + 1
			else
				direction	= "harddrop"	-- lock the piece into place if it can't move down any more
			end

		end

		if direction == "harddrop" then

			sounds.drop:stop()
			sounds.drop:play()
			playfield:placePiece(currentPiece, currentPiecePosition.x, currentPiecePosition.y)
			playfield:doGravity()
			self:update("afterPiece")

		end

	end




	function Game:test()
		love.graphics.print(tostring(gameState) .. ", T:" .. tostring(self:getGameStateTime()) , 50, 50)


	end

	---



	function Game:draw(x, y)

		love.graphics.setFont(fonts.numbers)

		playfield:draw(100, 100)
		if playerInput then
			currentPiece:draw(100, 100, currentPiecePosition.x, currentPiecePosition.y)
		end
		nextPiece:draw(300, 100, 1, 1)

		love.graphics.setColor(150, 150, 150)

		if currentChain then
			love.graphics.setFont(fonts.numbers)
			love.graphics.printf(string.format("%d\nx%2d", clearPoints, currentChain or 0), 300, 170, 99, "right")
			love.graphics.setColor(clearColors[math.min(#clearColors, currentChain)])
			love.graphics.setFont(fonts.bignumbers)
			love.graphics.printf(string.format("%d", clearPoints * (currentChain or 0)), 300, 190, 100, "right")
		end

		love.graphics.setFont(fonts.bignumbers)
		love.graphics.setColor(255, 255, 255)
		love.graphics.printf(string.format("%d", currentScore), 300, 220, 100, "right")

		love.graphics.setFont(fonts.numbers)
		love.graphics.printf(string.format("%.2f", gTimer), 300, 300, 100, "right")

		love.graphics.setFont(fonts.main)
	end



	return Game