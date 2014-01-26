
	-- Set includes to check classes/?.lua
	package.path	= package.path .. ";classes/?.lua"

	-- Include required classes
	LCS			= require("LCS")		-- Lua Class System
	Playfield	= require("Playfield")	-- Playfield
	Piece		= require("Piece")		-- Pieces




	-- Testing
	local test	= Playfield:new()
	print(test)
