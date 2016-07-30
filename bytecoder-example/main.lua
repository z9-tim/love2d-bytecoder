-- a list of compiled files to load in and run
local FilesToLoad= {
	[1] = "content/print_hello_world_compiled.luac",
}

local byte_error=false
local byte_error_string=""

GetBytecoderErrorString=function()

	return byte_error_string
	
end

for _, file in pairs( FilesToLoad ) do
	
	-- load in each file
	local loadok, errstr = pcall( function() assert( loadfile( file ) )() end )
	
	if not loadok then
	
		byte_error = true
		byte_error_string = errstr
		break
		
	end
	
end

if byte_error then

	love.draw = function()
	
		love.graphics.print( "ERROR: The game could not be loaded correctly. This is probably due to a corrupted installation or missing/damaged files.", 12, 12 )
		love.graphics.print( "Please reinstall the game.", 12, 24 )
		love.graphics.print( "Error string: " .. GetBytecoderErrorString(), 12, 48 )
		
	end
		
else

	GetBytecoderErrorString = nil
	
end
 