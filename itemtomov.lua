
function stripPath(thePath, theDelimitor)
	for i=string.len(thePath), 1, -1 do
		if string.byte(thePath, i) == string.byte(theDelimitor,1) then
			return(string.sub(thePath,1,i))
		end
	end
	return(false)
end

function pickfile(s)
	local tabledd = {}
	local tableddd = {}
	for i = 1, string.len(s) do
		table.insert(tabledd, 1, string.sub(s, i, i))
	end
	local a = ""
	for i = 1, table.getn(tabledd) do
		a = a..tabledd[i]
	end
	i, j = string.find(a, "\\")
	new = string.sub(a, 10, i-1)

	for i = 1, string.len(new) do
		table.insert(tableddd, 1, string.sub(new, i, i))
	end
	local b=""
	for i = 1, table.getn(tableddd) do
		b = b..tableddd[i]
	end
	return b
end


filedlg = iup.filedlg{dialogtype = "DIR", title = "Select_Output_folder"}  --, directory="c:\\"   -- Creates a file dialog and sets its type, title, filter and filter info
filedlg:popup (iup.ANYWHERE, iup.ANYWHERE)-- Shows file dialog in the center of the screen
status = filedlg.status-- Gets file dialog status
if status == "1" then
  pathOut = filedlg.value.."\\"
elseif status == "0" then
  pathOut = filedlg.value.."\\"
elseif status == "-1" then
  iup.Message("IupFileDlg","canceled")
end

--basicset
extraFrames = 0			-- lets render 10 frames in front and after the clip
proj = App():Project()
rc = App():RenderControl()
sub = proj:SubGet()							-- get the active cut
track = sub:TrackGet()							-- get the active track
clipCount = track:ClipCount()
filenametable = {}

--getfilename
selcount = 0
clipCount = track:ClipCount()
for c = 1, clipCount do
	clip = track:ClipGet( c - 1 )	-- indexes start from 0 !
	_in = clip:InPoint()			-- in and out are reserved keywords of lua !
	_out = clip:OutPoint()
	versionCount = clip:VersionCount()

	for v = 1, versionCount do

		item = clip:VersionGet( v - 1 )	-- indexes start from 0 !

		if item then
			filename = item:Filename()
			n = table.getn(filenametable)
			table.insert(filenametable, n+1, filename)
			App():Log( "    filename: " .. filename )
			loname = string.lower( filename )
		end
	end
end


tlist = {}

for i = 1, table.getn(filenametable) do
	woong = pickfile(filenametable[i])
	table.insert(tlist, woong)
end
dump(test)



--render
for i = 1, clipCount do
	clip = track:ClipGet( i - 1 )
	queue = rc:QueueCreate()					-- make a new render queue entry
	queue:SourceSet( track )					-- track is the source
	out = queue:OutputCreate()					-- add a new output for our queue
	out:RescaleMode( "ASPECT" )					-- rescaling mode "ASPECT", "FIT", "NOSCALE"
	out:Interface( "QUICKTIME" )					-- what video interface we are using
	out:Format( "SOR3" )						-- and what format
	out:Quality( 85 )							-- you can set the quality of the encoder if selected format supports it
	out:Width( 0 )							-- use input resolution
	out:Height( 0 )
	out:FrameStart( clip:InPoint() - extraFrames )		-- set our render start frame -10 frames of clip start
	out:FrameEnd( clip:OutPoint() + extraFrames - 1 )	-- render end at +10 frames of clip end
	out:Filename( pathOut ..tlist[i]..".mov" )  --clipPath ..
	rc:Render( queue )					-- this queue is ok to render !
end


