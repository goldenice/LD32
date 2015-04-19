
effect_table= {}
sounds = {}
effects = {images={},animations={}}
sound_effect_urls = {shoot = "assets/sounds/hit.wav"}
sound_effects = {}
function fill_effect_table()
  effect_table["explosion"] = explode_small
end
function add_effect (effect,x,y)
  gamestate.n_effects = gamestate.n_effects+1
  print(effect)
  print(effect_table[effect])
  local eff = effect_table[effect](x,y)
  eff.id = gamestate.n_effects
  gamestate.effects["a"..eff.id] = eff
end

function remove_effect (effect)
  gamestate.effects["a"..effect.id] = nil
end

function explode_small(x,y)
  local e = {}
  e.x = x
  e.y = y
  e.image = effects.images["explosion"]
  e.animation = effects.animations["explosion"]
  e.life = 0.2
  return e
end

function shoot_effect(x,y)
  local e = {}
  e.x = x
  e.y = y
  local src = love.audio.newSource(sound_effect_urls["shoot"], "static")
  src:play()
  e.life = 1
  return e
end
function draw_effects ()
  for _, effect in pairs(gamestate.effects) do
    if effect.life > 0 then
      if effect.animation then
        effect.animation:draw(effect.image, effect.x, effect.y)
      end
    else
      remove_effect(effect)
    end

  end
end
function update_effects (dt)
  for _, effect in pairs(gamestate.effects) do
    effect.life=effect.life-dt


  end
end
function get_effect_anims()
  animations = {explosion  ="assets/entity/player/standing_hflip/standing_hflip.png"}

  for name,file in pairs(animations) do
    local image = love.graphics.newImage(file)
    local g = anim8.newGrid(16, 24, image:getWidth(), image:getHeight())
    local anim = anim8.newAnimation(g('1-10',1), 1/60)
    effects.images[name] = image
    effects.animations[name] = anim

  end

end
function get_sound_effects()
  for name,file in pairs(sound_effect_urls) do
    sound_effects[name] = love.audio.newSource(file, "static")
  end


end
