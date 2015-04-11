iup.SetLanguage("ENGLISH")
text =""
fmt = "Search\nsearch Text:%100.20%s\n"
text = iup.Scanf (fmt, text)
App():Log( text )

--if you get iup then most in another value
makesub = text

searching = makesub			-- search string, find Bobs files


proj = App():Project()
proj:SelectionClear()

sub = proj:SubGet()			-- get current sub
App():Log( "Sub: " .. sub:Name() )

track = sub:TrackGet()		-- get current track
App():Log( " Track: " .. track:Name() )

selcount = 0

-- loop thru time slots
clipCount = track:ClipCount()
for c = 1, clipCount do

	clip = track:ClipGet( c - 1 )	-- indexes start from 0 !

	_in = clip:InPoint()			-- in and out are reserved keywords of lua !
	_out = clip:OutPoint()

	App():Log( "  clip:" .. _in .. " " .. _out )

	-- loop thru versions
	versionCount = clip:VersionCount()

	for v = 1, versionCount do

		item = clip:VersionGet( v - 1 )	-- indexes start from 0 !

		if item then
			length = item:Length()

			filename = item:Filename()

			App():Log( "   version: " .. v .. " refname " .. item:Name() .. " Length: " .. length )
			App():Log( "    filename: " .. filename )

			-- do some matching
			loname = string.lower( filename )
			find = string.lower( searching )

			if string.find( loname, find ) then
				App():Log( "match ! add to selection: " .. c - 1 .. " " .. v - 1 )
				proj:SelectionAdd( c - 1, v - 1 )	-- add this position to our selection !

				selcount = selcount + 1
			end
		end
	end

end

App():Log( "Search matched " .. selcount .. " times" )
