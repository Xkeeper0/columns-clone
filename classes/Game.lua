
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
		gameState			= false
		gameStateTime		= gTimer

		playerInput			= true
	end



	--- test
	function Game:update(newState)

		local firstRun		= false

		if newState then
			gameState		= newState
			gameStateTime	= gTimer
			firstRun		= true
		end

		-- Might need self added here???
		gameStates[gameState](firstRun)


		-- Something to do with game states here

	end



	function Game:pieceInPlay()
		playerInput	= true

		-- Gravity here?
		-- Otherwise do nothing of value because derp.

	end



	function Game:afterPiece(firstRun)
		
		if firstRun then
			playerInput	= false

			-- Check for clears?
			clears	= playfield:checkForClears()
			if clears then
				currentChain	= currentChain and (currentChain + 1) or 1
				clearPoints		= 100 * #clears * (currentLevel + 1)
				sounds.clear:stop()
				sounds.clear:setPitch(1 + math.pow(currentChain, 1.025))
				sounds.clear:play()
			else
				currentChain	= false
				-- Skip right to the after-gravity phase
				self:update('beforeNextPiece')
			end

		else

			-- Delay for a bit and/or animate?
			if self:getGameStateTime() > 0.5 then
				self:update('doClears')
			end

		end


	end


	function Game:doClears(firstRun)
		if firstRun then
			playfield:clearClears(clears)
			sounds.clear:stop()
			sounds.clear:setPitch(1 + math.pow(wasClear, 1.025))
			sounds.clear:play()		else
		end
		
		-- Delay for a bit and/or animate?
		if self:getGameStateTime() > 0.5 then
			self:update('doGravity')
		end			
	end


	function Game:doGravity(firstRun)
		if firstRun then
			totalScore	= totalScore + clearPoints * wasClear
			testPlayfield:doGravity()
			sounds.gravity:stop()
			sounds.gravity:play()
		else
			
			-- Go back and check if there are more clears.
			if self:getGameStateTime() > 0.5 then
				self:update('afterPiece')
			end			
		end
	end


	function Game:beforeNextPiece(firstRun)

		-- Delay for a while
		if self:getGameStateTime() > 1 then
			self:update('DO_NEXT_PIECE')
		end

	end


	function Game:nextPiece(firstRun)
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




	---
	function Game:movePiece(direction)

		local playSound	= false
		if direction == "left" then

		elseif direction == "right" then


		elseif direction == "down" then


		elseif direction == "harddrop" then

			sounds.drop:stop()
			sounds.drop:play()
			playfield:placePiece(currentPiece, currentPiecePosition.x, currentPiecePosition.y)
			playfield:doGravity()

		end

	end



	---
	function Game:getGameStateTime()
		return gameStateTime - gTimer;

	end



	return Game