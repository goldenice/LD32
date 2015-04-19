require 'bullet_types'
sx = 4
sy = 4

--gamestate,x,y,tick,scroll,rotation)
function delete_enemy(enemy)
  if enemy.isAsteroid then
    add_asteroid_small_enemy(gamestate,enemy.x,enemy.y,0,200,0)
    add_asteroid_small_enemy(gamestate,enemy.x,enemy.y,0,200,0)
  end
  gamestate.score =   gamestate.score  + enemy.score
  add_effect ("explosion",enemy.x,enemy.y)
  gamestate.blocks["a"..enemy.block] = nil
  gamestate.enemies["a"..enemy.id] = nil
  gamestate.world:remove(enemy)
end
function delete_bullet(bullet)

  gamestate.blocks["a"..bullet.block] = nil
  gamestate.bullets["a"..bullet.id] = nil
  gamestate.world:remove(bullet)

end
-- side = player or enemy
function add_bullet(x, y , rotation, type, side)
  gamestate.n_bullets = gamestate.n_bullets + 1
  gamestate.n_blocks = gamestate.n_blocks + 1
  w,h = bullet_type_images["standard"]:getDimensions()

  bullet = {x=x,y=y,w=w,h=h,rotation=rotation,type=type,side=side,isBullet=true, life=2}

  bullet.speed=500
  bullet.damage = 1
  gamestate.bullets["a"..gamestate.n_bullets]=bullet
  gamestate.blocks["a"..gamestate.n_blocks] = bullet
  gamestate.world:add(bullet,x,y,sx,sy)
  bullet.block =gamestate.n_blocks
  bullet.id =gamestate.n_bullets
  return bullet
end

function move_bullets(dt)

  for q,bullet in pairs(gamestate.bullets) do
    bullet.life=bullet.life-dt
    if bullet.life < 0 then
      delete_bullet(bullet)
    else
      local r = math.rad(bullet.rotation)
      local dx = math.sin(r)* bullet.speed * dt
      local dy = -math.cos(r)*bullet.speed*dt
      if bullet.side == "enemy" then
        bullet.x, bullet.y, cols, cols_len =gamestate.world:move(bullet, bullet.x + dx, bullet.y + dy,bullet_enemy_filter)
        for i=1,cols_len do
          if cols[i].other.isPlayer then
            player_is_hit()
            return
          end
        end
      else
        bullet.x, bullet.y, cols, cols_len =gamestate.world:move(bullet, bullet.x + 2*dx, bullet.y + 2*dy,bullet_player_filter)
        local hit = false
        for i=1,cols_len do
          if cols[i].other.isShield then
            hit = true
          end
          if cols[i].other.isPart then
            hit = true

            if cols[i].other.part == "front" then
              gamestate.boss.first_health = gamestate.boss.first_health -  bullet.damage
          end

          if cols[i].other.part == "left" then
            gamestate.boss.left_health = gamestate.boss.left_health -  bullet.damage
          end
          if cols[i].other.part == "right" then
            gamestate.boss.right_health = gamestate.boss.right_health -  bullet.damage
          end
        end
          if cols[i].other.isEnemy then

            hit = true
            cols[i].other.health = cols[i].other.health  - bullet.damage
            if cols[i].other.health  <= 0 then
              delete_enemy(cols[i].other)
              if cols[i].other.isBoss then
                gamestate.finished = true
              end
            end

          end
        end
        if hit then
          delete_bullet(bullet)
        end
      end
    end
  end
end

function draw_bullets()
  for _,bullet in pairs(gamestate.bullets) do
    love.graphics.draw(bullet.img, bullet.x+0.5*bullet.w,  bullet.y+0.5*bullet.h, math.rad(bullet.rotation), 1, 1,0.5*bullet.w,  0.5*bullet.h)
  end
end
function bullet_enemy_filter(item, other)

  return 'cross'

  -- else return nil
end

function bullet_player_filter(item, other)
  if other.isShield then
    return 'touch'
  end
  return 'cross'

  -- else return nil
end
