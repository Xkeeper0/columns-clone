
	-- Require Lua Class System
	LCS	= require("LCS")

	-- Create class
	Piece	= LCS.class({ w = 1, h = 3, layout = {} })



	--- Create a new piece
	-- @param blocks	Table of available block IDs to generate a piece with
	-- @param width		Width of piece
	-- @param height	Height of piece
	-- @param layout	Layout of piece, if forced (otherwise random)
	function Piece:init(blocks, width, height, layout)

		assert(blocks and #blocks > 0, "No blocks for this piece")

		if width and height and not layout then
			-- If width+height are given, use that
			self.w		= width
			self.h		= height

		elseif not width and not height and layout then
			-- If just a layout is given, use that
			self.layout	= layout

		elseif not width and not height and not layout then
			-- Use the defaults
			-- No code here because ... well, defaults

		else
			-- Some invalid combination of arguments was specified
			error("Got nonsense input for piece creation.")

		end



		if not layout then
			-- Generate a piece manually using the available blocks
			local numBlocks	= #blocks
			local x, y	= 0
			for x = 1, self.w do
				for y = 1, self.h do
					-- Insert the block into the piece's layout table
					table.insert(self.layout, {x = x - 1, y = y - 1, b = blocks[math.random(1, numBlocks)]})
				end
			end
		end

	end


	--- Output piece as a string
	function Piece:describe()
		local output	= "Piece:\n"
		for k, v in ipairs(self.layout) do
			output	= output .. string.format("%d: X=%d Y=%d B=%d\n", k, v.x, v.y, v.b)
		end
		return output
	end





	return Piece