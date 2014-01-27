
	--- Main file
	-- Work in progress
	-- @copyright Xkeeper 2014
	--

	-- Set includes to check classes/?.lua
	package.path	= package.path .. ";classes/?.lua"

	-- Include required classes
	LCS			= require("LCS")		-- Lua Class System
	Playfield	= require("Playfield")	-- Playfield
	Piece		= require("Piece")		-- Pieces




	-- Testing
	local test	= Playfield:new(6, 9)
	print(test)

	math.randomseed(os.clock())

	local i	= 0
	for i = 1, 50 do
		local testPiece	= Piece:new({1, 2, 3, 4}, 1, 3)
		test:placePiece(testPiece, math.random(1, 6), math.random(1, 10))
	end

	print "Playfield (now):"
	print(test)

	test:doGravity()
	print(test)


	-- This will probably crash everything

	local clears	= false

	repeat
		print "--------------------------------"
		print(test)
		clears	= test:checkForClears()
		test:clearClears(1, clears)
		test:doGravity()
	until (not clears)

