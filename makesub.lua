proj = App():Project()
sub = proj:SubGet()

iup.SetLanguage("ENGLISH")
text =""
fmt = "Makesub\nsubname:%250.40%s\n"


text = iup.Scanf (fmt, text)

App():Log( text )

--if you get iup then most in another value
makesub = text

if text then
	newsub = proj:SubCreate( makesub )
	newtrack = newsub:TrackCreate( makesub )
	App():LoadSub(newsub)
else
  iup.Message("MakeSub", "Operation canceled");
end
