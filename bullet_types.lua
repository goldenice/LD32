bullet_type_images = {}
bullet_types = {}
function   loadbullets()
  bullet_types["standard"] = add_standard_bullet
  bullet_types["wreck"] = add_standard_bullet
  bullet_type_images["standard"] =  love.graphics.newImage("assets/entity/bullets/bullet_round_001.png")
  bullet_type_images["wreck"] =  love.graphics.newImage("assets/entity/bullets/bullet_round_001.png")

end

function add_standard_bullet(x, y , rotation, side)
  local bullet = add_bullet(x, y , rotation, "standard", side)
  bullet.damage=1
  bullet.img = bullet_type_images["standard"]
end

function add_wreckingball(x,y,rotation,side)
  local bullet = add_bullet(x, y , rotation, "standard", side)
  bullet.damage=10

end
