
	-- Require Lua Class System
	LCS	= require("classes.LCS")

	-- Create class
	Game	= LCS.class()


	-- "Local variables"
	-- (i.e. 'protected')

	-- Points variables
	local currentPoints			= 0			-- (real) current score
	local displayPoints			= 0			-- in case I feel like making a fancy rolling counter
	local totalChain			= false		-- Total chain value (false if no chain)
	local currentChain			= false		-- Chain value for the current clear set
	local chainBroken			= true		-- True if the chain has broken.
	local clearPoints			= 0			-- Points for the most recent clear
	local chainPoints			= 0			-- Points for this chain, in total
	local thisChainPoints		= 0			-- Points for the last clear in this chain
	local displayChainPoints	= 0			-- Points for this chain, in total
	local clearedBlocks			= 0			-- Total blocks cleared
	local blocksCleared			= 0			-- Blocks cleared in latest clear
	local isMagicClear			= false		-- If this is a magic piece clear

	local totalPieces			= 0			-- Total pieces dropped (for later)
	local magicPieceRate		= 100		-- Every X pieces, drop a magic piece
	local currentLevel			= 0			-- Current game level
	local levelUpBlocks			= 50		-- Blocks per level

	-- Game status
	local gameOver				= false

	-- Our current and next pieces for playing
	local defaultPieceX			= 3
	local defaultPieceY			= -1
	local currentPiece			= false
	local currentPiecePosition	= { x = defaultPieceX, y = defaultPieceY }
	local nextPiece				= false
	local autoDown				= true
	local dasTime				= .2
	local dasTimer				= 0

	local gravityTiming			= {
		{	1.000,		2.500	},	-- 0
		{	0.900,		2.000	},
		{	0.800,		2.000	},
		{	0.700,		2.000	},
		{	0.600,		2.000	},
		{	0.500,		2.000	},	-- 5
		{	0.400,		1.500	},
		{	0.350,		1.500	},
		{	0.300,		1.500	},
		{	0.250,		1.500	},
		{	0.500,		1.000	},	-- 10
		{	0.350,		1.000	},
		{	0.250,		1.000	},
		{	0.200,		1.000	},
		{	0.150,		1.000	},
		{	0.100,		0.750	},	-- 15
		{	0.075,		0.750	},
		{	0.050,		0.750	},
		{	0.030,		0.750	},
		{	0.015,		0.700	},
		{	0.010,		0.500	},	-- 20
		{	0.005,		0.500	},
		{	0.003,		0.500	},
		{	0.001,		0.500	},
		{	0.000,		0.500	},	-- 24
	}

	local gravityTimer			= false						-- Last time we did gravity time (gameStateTime)
	local gravityTime			= gravityTiming[1][1]		-- How long it takes for a piece to move down one row
	local lockTimer				= false						-- When the piece stared to lock (gameStateTime)
	local lockTime				= gravityTiming[1][2]		-- How long until pieces lock





	local playfield				= false
	local blockTypes			= {1, 2, 3, 4}

	local clears				= false

	-- Current state we're in. Function pointer to what gets run?
	local gameState				= false

	local gameTimer				= 0

	-- Time when we went into this gamestate (used for timing)
	local gameStateTime	= 0

	-- Are we handling player input right now?
	local playerInput			= false

	--- Initialize a game
	-- What should this even do
	function Game:init(newPlayfield, blocks)

		-- Take in the playfield
		playfield			= newPlayfield or Playfield:new()
		blockTypes			= blocks and blocks or blockTypes

		-- Reset everything
		-- BIG UGLY BLOB OF CODE HERE --

		currentPoints			= 0			-- (real) current score
		displayPoints			= 0			-- in case I feel like making a fancy rolling counter
		totalChain				= false		-- Total chain value (false if no chain)
		currentChain			= false		-- Chain value for the current clear set
		chainBroken				= true		-- True if the chain has broken.
		clearPoints				= 0			-- Points for the most recent clear
		chainPoints				= 0			-- Points for this chain, in total
		thisChainPoints			= 0			-- Points for the last clear in this chain
		displayChainPoints		= 0			-- Points for this chain, in total
		clearedBlocks			= 0			-- Total blocks cleared
		blocksCleared			= 0			-- Blocks cleared in latest clear
		isMagicClear			= false		-- If this is a magic piece clear

		totalPieces				= 0			-- Total pieces dropped (for later)
		currentLevel			= 0			-- Current game level

		-- Game status
		gameOver				= false

		-- Our current and next pieces for playing
		currentPiecePosition	= { x = defaultPieceX, y = defaultPieceY }
		nextPiece				= false
		autoDown				= true
		dasTimer				= 0

		gravityTimer			= false						-- Last time we did gravity time (gameStateTime)
		gravityTime			= gravityTiming[1][1]		-- How long it takes for a piece to move down one row
		lockTimer				= false						-- When the piece stared to lock (gameStateTime)
		lockTime				= gravityTiming[1][2]		-- How long until pieces lock

		clears				= false

		-- Current state we're in. Function pointer to what gets run?
		gameState				= false
		gameTimer				= 0

		-- Time when we went into this gamestate (used for timing)
		gameStateTime	= 0

		-- Are we handling player input right now?
		playerInput			= false




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
		gameStateTime		= gameTimer

		gravityTimer		= gameStateTime

		playerInput			= true
	end


	function Game:getGameStateTime()
		return gameTimer - gameStateTime

	end


	function Game.pieceInPlay(self, firstRun)

		if (firstRun) then
			gravityTimer	= gameStateTime
			playerInput	= true
		end

		while (gameTimer - gravityTimer) > gravityTime do

			if self:doPieceGravity() then
				-- I think this works?
				-- Add (difference between timers) to the other timer
				-- This way if the game lags for however long it'll drop more than one row or something

				gravityTimer	= (gravityTimer + gravityTime)
				if lockTimer then
					-- If a piece was floating and is now free, just move it down once
					gravityTimer	= gameTimer
					lockTimer		= false
				end
			else
				if not lockTimer then
					lockTimer	= gameTimer
					sounds.drop:stop()
					sounds.drop:play()
				else
					if gameTimer - lockTimer > lockTime then
						self:movePiece("harddrop")
					end
				end

				-- Break out of gravity loop
				break
			end
		end


	end


	function Game.afterPiece(self, firstrun)

		playerInput			= false
		autoDown			= false
		totalPieces			= totalPieces + 1
		currentChain		= false
		chainBroken			= true

		self:runState('doClearCheck')

	end



	function Game.doClearCheck(self, firstRun)

		if firstRun then

			-- Check for clears
			clears, isMagicClear	= playfield:checkForClears()
			if clears then
				clearPoints			= 0
				local base			= 100
				if isMagicClear then
					base			= 10
				end

				blocksCleared	= 0
				for k, v in pairs(clears) do
					blocksCleared	= blocksCleared + #v
				end

				clearedBlocks		= clearedBlocks + blocksCleared

				-- Add a block penalty so 3 = base, 4 = base * 2, etc.
				blocksCleared		= blocksCleared - 2
				clearPoints			= base * blocksCleared

				-- Increment the global chain
				totalChain			= totalChain and (totalChain + 1) or 1

				-- Increment the current chain
				currentChain		= currentChain and currentChain + 1 or 1

				-- Set the clearpoints by level
				clearPoints			= clearPoints * (currentLevel + 1)

				-- Chain not broken this clear
				chainBroken			= false

				thisChainPoints	= clearPoints * totalChain * currentChain
			else
				-- Allow chains to continue for one drop
				totalChain			= currentChain and totalChain or false

				-- Skip right to the after-gravity phase
				self:runState('beforeNextPiece')
			end

		else

			-- Delay for a bit and/or animate?
			if self:getGameStateTime() > 0.25 then
				self:runState('doClears')
			end

		end


	end


	function Game.doClears(self, firstRun)
		if firstRun then
			playfield:clearClears(clears, 1, -1)
			if isMagicClear then
				sounds.magic:stop()
				sounds.magic:play()
			else
				sounds.clear:stop()
				sounds.clear:setPitch(1 + (totalChain - 1) * 0.1)
				sounds.clear:play()

			end
		end

		-- Delay for a bit and/or animate?
		if self:getGameStateTime() > 0.25 then
			playfield:clearClears(clears)
			self:runState('doLevelUp')
		end
	end



	function Game.doLevelUp(self, firstRun)

		if math.floor(clearedBlocks / levelUpBlocks) > currentLevel then
			-- Play "level up" sound
			sounds.levelup:stop()
			sounds.levelup:play()
			-- Increment level by one

			currentLevel	= math.floor(clearedBlocks / levelUpBlocks)

			local speedLevel	= math.min(currentLevel + 1, #gravityTiming)
			gravityTime			= gravityTiming[speedLevel][1]
			lockTime			= gravityTiming[speedLevel][2]

		end

		self:runState('doGravity')

	end




	function Game.doGravity(self, firstRun)
		if firstRun then

			if totalChain then
				chainPoints		= chainPoints + thisChainPoints
			end

			playfield:doGravity()
			sounds.gravity:stop()
			sounds.gravity:play()
		else

			-- Go back and check if there are more clears.
			if self:getGameStateTime() > 0.25 then
				self:runState('doClearCheck')
			end
		end
	end


	function Game.beforeNextPiece(self, firstRun)

		if not totalChain then
			currentPoints		= currentPoints + chainPoints
			chainPoints			= 0
			displayChainPoints	= 0
		end

		-- Delay for a while
		if self:getGameStateTime() > .1 then
			self:runState('nextPiece')
		end

	end


	function Game.nextPiece(self, firstRun)
		currentPiece			= nextPiece
		currentPiecePosition	= { x = defaultPieceX, y = defaultPieceY }
		nextPiece				= Piece:new(math.fmod(totalPieces, magicPieceRate) == 0 and {99} or blockTypes)

		gravityTimer			= gameStateTime
		lockTimer				= false

		if not playfield:canPlacePiece(currentPiece, currentPiecePosition.x , currentPiecePosition.y) then
			self:runState('doGameOver')
			return
		end


		self:runState('pieceInPlay')
	end


	function Game.doGameOver(self, firstRun)

		playerInput	= false
		gameOver	= true

	end



	local gameStates	= {

		pieceInPlay		= Game.pieceInPlay,
		afterPiece		= Game.afterPiece,
		doClearCheck	= Game.doClearCheck,
		doClears		= Game.doClears,
		doLevelUp		= Game.doLevelUp,
		doGravity		= Game.doGravity,
		beforeNextPiece	= Game.beforeNextPiece,
		nextPiece		= Game.nextPiece,
		doGameOver		= Game.doGameOver,

	}



	--- test
	function Game:runState(newState)

		local firstRun		= false

		if newState then
			gameState		= newState
			gameStateTime	= gameTimer
			firstRun		= true
		end


		gameStates[gameState](self, firstRun and true or false)


	end



	---
	function Game:update(dt)
		gameTimer	= gameTimer + dt

		self:runState()
	end



	--- Move the piece downwards, in accordance with gravity
	function Game:doPieceGravity(givePoints)

		if playfield:canPlacePiece(currentPiece, currentPiecePosition.x , currentPiecePosition.y + 1) then
			currentPiecePosition.y	= currentPiecePosition.y + 1
			if givePoints then
				currentPoints	= currentPoints + (currentLevel + 1)
				gravityTimer	= gameTimer
			end
			return true
		end

		return false

	end


	---
	function Game:movePiece(direction, skipStateChange, isRepeat)

		if not playerInput then
			return
		end

		if direction == "cycle" then
			sounds.cycle:stop()
			sounds.cycle:play()

			currentPiece:cycleBlocks()

		elseif direction == "left" and (not isRepeat or (isRepeat and (dasTimer + dasTime) < gameTimer)) then
			if not isRepeat then
				dasTimer	= gameTimer
			end

			if playfield:canPlacePiece(currentPiece, currentPiecePosition.x - 1, currentPiecePosition.y) then
				sounds.move:stop()
				sounds.move:play()
				currentPiecePosition.x	= currentPiecePosition.x - 1
			end
		elseif direction == "right" and (not isRepeat or (isRepeat and (dasTimer + dasTime) < gameTimer)) then
			if not isRepeat then
				dasTimer	= gameTimer
			end

			if playfield:canPlacePiece(currentPiece, currentPiecePosition.x + 1, currentPiecePosition.y) then
				sounds.move:stop()
				sounds.move:play()
				currentPiecePosition.x	= currentPiecePosition.x + 1
			end

		elseif direction == "down" and (not isRepeat or (isRepeat and autoDown)) then
			-- Enable auto-dropping for this piece
			autoDown	= true
			if not self:doPieceGravity(true) then
				direction	= "harddrop"	-- lock the piece into place if it can't move down any more
			end

		end

		if direction == "harddrop" then

			repeat
				-- forever
			until not self:doPieceGravity(true)

			sounds.lock:stop()
			sounds.lock:play()
			playfield:placePiece(currentPiece, currentPiecePosition.x, currentPiecePosition.y)
			playfield:doGravity()
			if not skipStateChange then
				self:runState("afterPiece")
			end

		end

	end




	function Game:showGameState()
		love.graphics.print(string.format("%s\nT=%.2f", gameState, self:getGameStateTime()) , 50, 50)
	end

	---



	function Game:draw(hidePlayfield)

		if displayPoints < currentPoints then
			-- Rolling counter goofiness
			displayPoints	= math.min(displayPoints + math.floor((currentPoints - displayPoints) * 0.02) + 1 + currentLevel, currentPoints)
		end

		if displayChainPoints < chainPoints then
			-- Rolling counter goofiness
			displayChainPoints	= math.min(displayChainPoints + (chainPoints - displayChainPoints) * 0.08 + 1, chainPoints)
		end

		love.graphics.setFont(fonts.numbers)

		love.graphics.draw(backgroundP, 18 * 4, 18 * 3)
		if not hidePlayfield then
			playfield:draw(18 * 4 + 1, 18 * 3 + 1, 1, self:getGameStateTime())
			if playerInput or gameOver then
				currentPiece:draw(18 * 4 + 1, 18 * 3 + 1, currentPiecePosition.x, (currentPiecePosition.y) - 1 + math.min(1, ((gameTimer - gravityTimer) / gravityTime)))
			end
			nextPiece:draw(18 * 12 + 1, 18 * 3 + 1, 1, 1)
		end

		love.graphics.setColor(150, 150, 150)

		if totalChain then
			love.graphics.setFont(fonts.numbers)
			--love.graphics.printf(string.format("x%d\nx%d", totalChain or 0, currentChain or 0), 300, 120, 98, "right")

			love.graphics.setFont(fonts.bignumbers)

			love.graphics.printf(string.format("x%d", (totalChain or 0) * (currentChain or 0)), 300, 120, 100, "right")

			if totalChain then
				love.graphics.setColor(clearColors[math.min(#clearColors, totalChain)])
			end
			love.graphics.printf(string.format("%d", thisChainPoints), 300, 140, 100, "right")
			love.graphics.setColor(255, 255, 255)
			love.graphics.printf(string.format("%d", displayChainPoints), 300, 170, 100, "right")
			love.graphics.printf(string.format("%d", clearPoints), 300, 100, 100, "right")
		end

		love.graphics.setFont(fonts.bignumbers)
		love.graphics.setColor(255, 255, 255)
		love.graphics.printf(string.format("%d", displayPoints), 300, 220, 100, "right")

		love.graphics.setFont(fonts.numbers)
		love.graphics.printf(string.format("%d", clearedBlocks), 300, 260, 99, "right")
		love.graphics.printf(string.format("%d", currentLevel), 300, 276, 99, "right")
		love.graphics.printf(string.format("%d", totalPieces), 300, 292, 99, "right")

		love.graphics.setFont(fonts.numbers)
		love.graphics.printf(string.format("%.2f", gameTimer), 540, 1, 100, "right")

		love.graphics.setFont(fonts.main)

		if totalChain then
			love.graphics.print("base clear", 402, 100)
			love.graphics.print("chain", 402, 120)
			love.graphics.print("clear value", 402, 140)
			love.graphics.print("chain value", 402, 170)
		end

		love.graphics.print("total points", 402, 220)
		love.graphics.print("blocks", 402, 257)
		love.graphics.print("level", 402, 257 + 16)
		love.graphics.print("pieces", 402, 257 + 32)

		love.graphics.setFont(fonts.numbers)

		love.graphics.printf(string.format("%5.3f\n%5.3f\n\n%5.3f\n%5.3f", gravityTime - (gameTimer - gravityTimer), gravityTime, lockTimer and (lockTime - (gameTimer - lockTimer)) or lockTime, lockTime), 400, 370, 100, "right")

		love.graphics.setFont(fonts.main)
		love.graphics.print("gravity time\n\nlock time", 500, 370)


		if gameOver then
			love.graphics.print("game over.", 250, 130)
		end

	end



	return Game