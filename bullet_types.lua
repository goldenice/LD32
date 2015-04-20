
bullet_type_images = {}
bullet_types = {}
function   loadbullets()
  bullet_types["standard"] = add_standard_bullet
  bullet_types["wreck"] = add_standard_bullet
  bullet_types["ion"] = add_ion_bullet

  bullet_type_images["standard"] =  love.graphics.newImage("assets/entity/bullets/bullet_round_001.png")
  bullet_type_images["standard_enemy"] =  love.graphics.newImage("assets/entity/bullets/bullet_round_yellow1.png")
  bullet_type_images["ion"] =  love.graphics.newImage("assets/entity/bullets/bullet_huge_001.png")

  bullet_type_images["wreck"] =  love.graphics.newImage("assets/entity/specials/wrecking_ball_chainless_001.png")

end

function add_standard_bullet(x, y , rotation, side)

  local bullet = add_bullet(x, y , rotation, "standard", side)
  bullet.damage=1
  bullet.img = bullet_type_images["standard"]
end

function add_standard_enemy_bullet(x, y , rotation, side)

    local bullet = add_bullet(x, y , rotation, "standard", side)
    bullet.damage=1
    bullet.img = bullet_type_images["standard_enemy"]
    bullet.speed = 250
    bullet.life= 4
end
function add_ion_enemy_bullet(x, y , rotation, side)
  local bullet = add_bullet(x, y , rotation, "standard", side)
  bullet.life= 4
  bullet.damage=1
  bullet.img = bullet_type_images["ion"]
  bullet.width = 32
  bullet.height = 32
  bullet.w = bullet.width
  bullet.h = bullet.height
  bullet.speed = 250

end

function add_3_spread_bullet(x, y , rotation, side)

if side == "enemy"
then
    add_standard_enemy_bullet(x, y , rotation-15, side)
    add_standard_enemy_bullet(x, y , rotation, side)
    add_standard_enemy_bullet(x, y , rotation+15, side)
    else
    add_standard_bullet(x, y , rotation-10, side)
    add_standard_bullet(x, y , rotation, side)
    add_standard_bullet(x, y , rotation+10, side)
    end
end

function add_5_spread_bullet(x, y , rotation, side)
if side == "enemy"
then3
    add_standard_enemy_bullet(x, y , rotation-30, side)
    add_standard_enemy_bullet(x, y , rotation-15, side)
    add_standard_enemy_bullet(x, y , rotation, side)
    add_standard_enemy_bullet(x, y , rotation+15, side)
    add_standard_enemy_bullet(x, y , rotation+30, side)
    else
    add_standard_bullet(x, y , rotation-20, side)
    add_standard_bullet(x, y , rotation-10, side)
    add_standard_bullet(x, y , rotation, side)
    add_standard_bullet(x, y , rotation+10, side)
    add_standard_bullet(x, y , rotation+20, side)
    end
end

function add_360_spread_bullet(x, y , rotation, side)
if side == "enemy"
then
    add_standard_enemy_bullet(x, y , rotation-180, side)
    add_standard_enemy_bullet(x, y , rotation-165, side)
    add_standard_enemy_bullet(x, y , rotation-150, side)
    add_standard_enemy_bullet(x, y , rotation-135, side)
    add_standard_enemy_bullet(x, y , rotation-120, side)
    add_standard_enemy_bullet(x, y , rotation-105, side)
    add_standard_enemy_bullet(x, y , rotation-90, side)
    add_standard_enemy_bullet(x, y , rotation-75, side)
    add_standard_enemy_bullet(x, y , rotation-60, side)
    add_standard_enemy_bullet(x, y , rotation-45, side)
    add_standard_enemy_bullet(x, y , rotation-30, side)
    add_standard_enemy_bullet(x, y , rotation-15, side)
    add_standard_enemy_bullet(x, y , rotation, side)
    add_standard_enemy_bullet(x, y , rotation+15, side)
    add_standard_enemy_bullet(x, y , rotation+30, side)
    add_standard_enemy_bullet(x, y , rotation+45, side)
    add_standard_enemy_bullet(x, y , rotation+60, side)
    add_standard_enemy_bullet(x, y , rotation+75, side)
    add_standard_enemy_bullet(x, y , rotation+90, side)
    add_standard_enemy_bullet(x, y , rotation+105, side)
    add_standard_enemy_bullet(x, y , rotation+120, side)
    add_standard_enemy_bullet(x, y , rotation+135, side)
    add_standard_enemy_bullet(x, y , rotation+150, side)
    add_standard_enemy_bullet(x, y , rotation+165, side)
    else
    add_standard_bullet(x, y , rotation-1800, side)
    add_standard_bullet(x, y , rotation-170, side)
    add_standard_bullet(x, y , rotation-160, side)
    add_standard_bullet(x, y , rotation-150, side)
    add_standard_bullet(x, y , rotation-140, side)
    add_standard_bullet(x, y , rotation-130, side)
    add_standard_bullet(x, y , rotation-120, side)
    add_standard_bullet(x, y , rotation-110, side)
    add_standard_bullet(x, y , rotation-100, side)
    add_standard_bullet(x, y , rotation-90, side)
    add_standard_bullet(x, y , rotation-80, side)
    add_standard_bullet(x, y , rotation-70, side)
    add_standard_bullet(x, y , rotation-60, side)
    add_standard_bullet(x, y , rotation-50, side)
    add_standard_bullet(x, y , rotation-40, side)
    add_standard_bullet(x, y , rotation-30, side)
    add_standard_bullet(x, y , rotation-20, side)
    add_standard_bullet(x, y , rotation-10, side)
    add_standard_bullet(x, y , rotation, side)
    add_standard_bullet(x, y , rotation+10, side)
    add_standard_bullet(x, y , rotation+20, side)
    add_standard_bullet(x, y , rotation+30, side)
    add_standard_bullet(x, y , rotation+40, side)
    add_standard_bullet(x, y , rotation+50, side)
    add_standard_bullet(x, y , rotation+60, side)
    add_standard_bullet(x, y , rotation+70, side)
    add_standard_bullet(x, y , rotation+80, side)
    add_standard_bullet(x, y , rotation+90, side)
    add_standard_bullet(x, y , rotation+100, side)
    add_standard_bullet(x, y , rotation+110, side)
    add_standard_bullet(x, y , rotation+120, side)
    add_standard_bullet(x, y , rotation+130, side)
    add_standard_bullet(x, y , rotation+140, side)
    add_standard_bullet(x, y , rotation+150, side)
    add_standard_bullet(x, y , rotation+160, side)
    add_standard_bullet(x, y , rotation+170, side)
    end
end

function add_wreckingball(x,y,rotation,side)
  local bullet = add_bullet(x, y , rotation, "standard", side)
  bullet.damage=10

end
