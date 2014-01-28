
	-- Require Lua Class System
	LCS	= require("classes.LCS")

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
		for k, v in pairs(self.layout) do
			output	= output .. string.format("%d: X=%d Y=%d B=%d\n", k, v.x, v.y, v.b)
		end
		return output
	end




	--- Temporary ugly way to draw a piece to the playfield
	function Piece:draw(xPosition, yPosition, pieceX, pieceY)
		for k, v in pairs(self.layout) do
			love.graphics.setColor(blockColors[v.b])
			love.graphics.print(string.format("%2d", v.b), xPosition + ((pieceX - 1 + v.x) * 20), yPosition + ((pieceY - 1 + v.y) * 20))
		end
	end


	--- Return the piece's layout as a table
	function Piece:getLayout()
		return self.layout

	end



	function Piece:cycleBlocks()

		local i, numBlocks, top	= 1, #self.layout, self.layout[1]['b']

		for i = 1, numBlocks do
			local next	= (i + 1 > numBlocks) and 1 or i + 1
			self.layout[i]['b']	= self.layout[next]['b']
		end

		self.layout[numBlocks]['b']	= top


	end

	return Piece