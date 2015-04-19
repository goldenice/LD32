
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
  local g = effects.animations["explosion"]
  e.animation =  anim8.newAnimation(g('1-8',1), 0.1)
  e.life = 0.8
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
    effect.animation:update(dt)
    effect.life=effect.life-dt


  end
end
function get_effect_anims()
  animations = {explosion  ="assets/animation/explosion_small_001.png"}

  for name,file in pairs(animations) do
    local image = love.graphics.newImage(file)
    effects.animations[name] = anim8.newGrid(image:getHeight(), image:getHeight(), image:getWidth(), image:getHeight())
    effects.images[name] = image

  end

end
function get_sound_effects()
  for name,file in pairs(sound_effect_urls) do
    sound_effects[name] = love.audio.newSource(file, "static")
  end


end
