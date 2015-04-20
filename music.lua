function playtrack(trackid)
  local soundIntro = ""
  local soundLoop = ""
  local soundEnd = ""

  if trackid == "boss"
  then
    soundIntro = "assets/music/boss_intro.wav"
    soundLoop = "assets/music/boss_loop.wav"
    soundEnd = ""
    print("1 reached")
  end

  if trackid == "1"
  then
    soundIntro = "assets/music/theme_loop.wav"
    soundLoop = "assets/music/theme_loop.wav"
    soundEnd = ""
  end

  if playingtrack ~= nil
  then

    func = function(d) playtrack(trackid) end
    --[[

    funcnext = function(d) playtrack(trackid) end

    func = function(d) TEsound.play(soundEnd, tags, volume, pitch, funcnext) end

--]]


    TEsound.queuenext(1, 1, func)

    playingtrack=nil

  else

    func = function(d) TEsound.playLooping(soundLoop, "music", nil, 1, 1) end

    TEsound.play(soundIntro, "music", 1, 1, func)
    --]]
    playingtrack=trackid


  end






end
