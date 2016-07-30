bytecoder = {}

bytecoder.OutputFolder = "compiled"
bytecoder.OutputFiletype = ".luac"

--[[

	WHERE TO PLACE/FIND YOUR FILES (modified from the Love2D wiki)

	Each game is granted a single directory on the system where files can be saved through love.filesystem. This is the only directory where love.filesystem can write files. These directories will typically be found in something like:

	Windows XP: C:\Documents and Settings\user\Application Data\LOVE\bytecoder\ or %appdata%\LOVE\bytecoder\

	Windows Vista and 7: C:\Users\user\AppData\Roaming\LOVE\bytecoder\ or %appdata%\LOVE\bytecoder\

	Linux: $XDG_DATA_HOME/love/bytecoder/ or ~/.local/share/love/bytecoder/

	Mac: /Users/user/Library/Application Support/LOVE/bytecoder/

]]--

love.load = function()
	
	bytecoder.OutputFolder = "/" .. bytecoder.OutputFolder
	
	-- check dirs
	if not love.filesystem.exists( "/original" ) then
	
		love.filesystem.createDirectory( "/original" )
		
	end
	
	if not love.filesystem.exists( bytecoder.OutputFolder ) then
	
		love.filesystem.createDirectory( bytecoder.OutputFolder )
		
	else
		
		-- compiled folder already exists, so let's check to see if we have any leftover compiles from earlier runs
		for k, file in pairs( love.filesystem.getDirectoryItems( bytecoder.OutputFolder ) ) do
		
			if love.filesystem.isFile( bytecoder.OutputFolder .. "/" .. file ) and ( file:sub( -bytecoder.OutputFiletype:len() ) == bytecoder.OutputFiletype ) then
			
				if love.filesystem.exists( "/original/" .. file:sub( -bytecoder.OutputFiletype:len() ) .. ".lua" ) then
				
					love.filesystem.remove( bytecoder.OutputFolder .. "/" .. file )
				
				end
			
			end
		
		end
	
	end
	
	-- iterate through all the items in the original folder and write out the compiled bytecode
	for k, file in pairs( love.filesystem.getDirectoryItems( "/original" ) ) do
		
		-- only compile lua scripts...
		if file:sub( -3 ) == "lua" then
			
			-- try reading it in
			print( "[BYTECODER] Processing Lua file \"" .. "/original/" .. file .. "\"..." )
			
			local chunk = love.filesystem.load( "/original/" .. file )
			
			if chunk then -- load went ok
				
				-- spit the string representation into the output folder
				
				local destinationfile = bytecoder.OutputFolder .. "/" .. file:sub( 1, file:len() - 4 ) .. bytecoder.OutputFiletype
				
				love.filesystem.write( destinationfile, string.dump( chunk, false ) )
				
				print( "[BYTECODER] ...saved new file \"" .. destinationfile .. "\"." )
			
			else -- load didn't go ok
			
				print( "[BYTECODER] ...processing failed for that one, skipping it over." )
			
			end
			
		end
	
	end
	
	print( "If you can read this but nothing was processed, make sure your folders are set up correctly." )
	
end
 