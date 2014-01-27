
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
	local test	= Playfield:new()
	print(test)


	local testPiece	= Piece:new({1, 2, 3, 4, 5}, 1, 3)
	print(testPiece)
