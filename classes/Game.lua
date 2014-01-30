
	-- Require Lua Class System
	LCS	= require("classes.LCS")

	-- Create class
	Game	= LCS.class()


	-- "Local variables"
	-- (i.e. 'protected')

	-- Points variables
	local currentPoints			= 0			-- (real) current score
	local displayPoints			= 0			-- in case I feel like making a fancy rolling counter
	local currentChain			= false		-- Current chain value (false if no chain)
	local lastChain				= false		-- Last chain value (or false if no chain)
	local clearPoints			= 0			-- Points for the most recent clear
	local chainPoints			= 0			-- Points for this chain, in total
	local displayChainPoints	= 0			-- Points for this chain, in total
	local clearedBlocks			= 0			-- Total blocks cleared
	local blocksCleared			= 0			-- Blocks cleared in latest clear

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
				clearPoints			= 0
				local base			= 100
				
				blocksCleared	= 0
				for k, v in pairs(clears) do
					blocksCleared	= blocksCleared + #v
				end

				clearedBlocks	= clearedBlocks + blocksCleared

				-- Add a block penalty so 3 = base, 4 = base * 2, etc.
				blocksCleared	= blocksCleared - 2
				clearPoints		= base * blocksCleared

				currentChain	= currentChain and (currentChain + 1) or 1
				lastChain		= currentChain
				clearPoints		= clearPoints * (currentLevel + 1)
			else
				-- Allow chains to continue for one drop
				currentChain	= lastChain and lastChain or false
				lastChain		= false
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
			sounds.clear:setPitch(1 + (currentChain - 1) * 0.1)
			sounds.clear:play()		else
		end

		-- Delay for a bit and/or animate?
		if self:getGameStateTime() > 0.25 then
			self:update('doGravity')
		end			
	end


	function Game.doGravity(self, firstRun)
		if firstRun then

			if currentChain then
				chainPoints	= chainPoints + clearPoints * currentChain
			end

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

		if not currentChain then
			currentPoints		= currentPoints + chainPoints
			chainPoints			= 0
			displayChainPoints	= 0

		end

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


		gameStates[gameState](self, firstRun and true or false)


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
				currentPiecePosition.y	= currentPiecePosition.y + 1
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




	function Game:showGameState()
		love.graphics.print(string.format("%s\nT=%.2f", gameState, self:getGameStateTime()) , 50, 50)
	end

	---



	function Game:draw(x, y)

		if displayPoints < currentPoints then
			-- Rolling counter goofiness
			displayPoints	= math.min(displayPoints + (currentPoints - displayPoints) * 0.02 + 1, currentPoints)
		end

		if displayChainPoints < chainPoints then
			-- Rolling counter goofiness
			displayChainPoints	= math.min(displayChainPoints + (chainPoints - displayChainPoints) * 0.08 + 1, chainPoints)
		end

		love.graphics.setFont(fonts.numbers)

		playfield:draw(100, 50)
		if playerInput then
			currentPiece:draw(100, 50, currentPiecePosition.x, currentPiecePosition.y)
		end
		nextPiece:draw(250, 50, 1, 1)

		love.graphics.setColor(150, 150, 150)

		if currentChain then
			love.graphics.setFont(fonts.numbers)
			love.graphics.printf(string.format("%d\nx%2d", clearPoints, currentChain or 0), 300, 130, 99, "right")
			love.graphics.setColor(clearColors[math.min(#clearColors, currentChain)])
			love.graphics.setFont(fonts.bignumbers)
			love.graphics.printf(string.format("%d", clearPoints * (currentChain or 0)), 300, 150, 100, "right")
			love.graphics.setColor(255, 255, 255)
			love.graphics.printf(string.format("%d", displayChainPoints), 300, 170, 100, "right")
		end

		love.graphics.setFont(fonts.bignumbers)
		love.graphics.setColor(255, 255, 255)
		love.graphics.printf(string.format("%d", displayPoints), 300, 220, 100, "right")

		love.graphics.setFont(fonts.numbers)
		love.graphics.printf(string.format("%d", clearedBlocks), 300, 260, 99, "right")


		love.graphics.setFont(fonts.numbers)
		love.graphics.printf(string.format("%.2f", gTimer), 540, 1, 100, "right")

		love.graphics.setFont(fonts.main)
		love.graphics.print("points", 402, 225)
		love.graphics.print("blocks", 402, 257)

	end



	return Game