function playtrack(trackid)
  if trackid == "1"
  then
    local soundIntro = "assets/music/boss_intro.wav"
    local soundLoop = "assets/music/boss_loop.wav"
    local soundEnd = ""
  end

  if trackid == "boss"
  then
    local soundIntro = "assets/music/theme_loop.wav"
    local soundLoop = "assets/music/theme_loop.wav"
    local soundEnd = ""
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

    func = function(d) TEsound.playLooping(soundLooping, "music", nil, 1, 1) end

    TEsound.play(soundIntro, "music", 1, 1, func)

    playingtrack=1


  end






end
