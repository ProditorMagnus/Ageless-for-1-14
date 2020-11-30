local helper = wesnoth.require "lua/helper.lua"
local AH = wesnoth.require "ai/lua/ai_helper.lua"   
local AAH = wesnoth.require "~add-ons/Ageless_Era/lua/archaic_era_ai_helper.lua"   
local BC = wesnoth.require "ai/lua/battle_calcs.lua"

-- current status is that it gets ignored, probably too much filter at line 32
local ca_plague_attack = {}

function ca_plague_attack:evaluation(cfg, data)
  -- this may be too simple-minded...
	--	wesnoth.message("start evaluation")

   local all_units = wesnoth.get_units({ side = wesnoth.current.side })

  -- find units that have the plague special
   local units = {}
--   local weapon_number = 0
   for _,unit in ipairs(all_units) do
	local hws = nil
	hws,weapon_number = AAH.has_weapon_special(unit,"damage","aa_k_enth")
--		wesnoth.message(string.format("considering %s and %s weapon special", unit.__cfg.name,hws))
       if hws and (unit.attacks_left > 0) then
          table.insert(units, unit)
--		wesnoth.message("found a khthon")
       end
   end
   if (not units[1]) then return 0 end

   local attacks = AAH.get_attacks(units, { simulate_combat = true , weapon_id = "aa_khthon_enthrall_attack"})
   if (not attacks[1]) then 
--	wesnoth.message("no attacks found")
   	return 0 
   end


   local avg_hp = 0
   local best_attack = nil
   for _,attack in pairs(attacks) do
--		wesnoth.message(string.format("attack %s being considered", attack.att_weapon.name))
              -- Only consider attack if it uses the plague weapon to (probably) kill the defender 
              -- and there is no chance to die or to be poisoned or slowed, 
              -- then find attack with lowest HP loss
        if (attack.att_weapon.name == "aa_khthon_enthrall_attack")
          and (attack.att_stats.hp_chance[0] == 0) 
          and (attack.att_stats.poisoned == 0) 
          and (attack.att_stats.slowed == 0)
	  and (attack.att_stats.average_hp >= avg_hp)
          and (attack.def_stats.hp_chance[0] > 0) 
        then 
	        local is_pl = true
		local enemy = wesnoth.get_unit(attack.target.x,attack.target.y)
		  -- find susceptable enemies they can attack
--		wesnoth.match_unit() is useless
--		local is_pl = wesnoth.match_unit(enemy,{ {"not", {{"status", {unplagueable = "yes" }}} } }) --always evaluates to 'false'
--		local is_pl = wesnoth.match_unit(enemy,{ {"status", {unplagueable = "yes" }} }) -- always evaluates to 'true'
--		local is_up = wesnoth.match_unit(enemy,{ {"status", {poopy = "yes" } }})
		local enemy_status = helper.get_child(enemy.__cfg, "status")
		if enemy_status.unplageable == true 
		  or enemy_status.not_living == true 
		then
			is_pl = false
		end
--		wesnoth.message(string.format("enthrall attack found, checking if %s is unplageable: %s ", enemy.__cfg.name, is_pl))
		if is_pl then
			best_attack = attack
			avg_hp = attack.att_stats.average_hp
		else
--			wesnoth.message(string.format("%s not plagueable, aborting", enemy.__cfg.name))
  		end
	end  
   end
  
  
  
  
    if best_attack then
    	data.PU_best_attack = best_attack
        return 105000
    end
    return 0
end


function ca_plague_attack:execution(cfg, data)
    local attacker = wesnoth.get_unit(data.PU_best_attack.src.x, data.PU_best_attack.src.y)
    local defender = wesnoth.get_unit(data.PU_best_attack.target.x, data.PU_best_attack.target.y)
    local def_type = defender.type
    local weapon = -1
        
    AH.movefull_stopunit(ai, attacker, data.PU_best_attack.dst.x, data.PU_best_attack.dst.y)
    if (not attacker) or (not attacker.valid) then return end
    if (not defender) or (not defender.valid) then return end
-- the case where the attack is interrupted, by a concealed unit, for example.
    if (helper.distance_between(attacker.__cfg.x, attacker.__cfg.y, defender.__cfg.x, defender.__cfg.y) ~= 1) then return end
    

                    
-- need to find which weapon index represents the plague, even though we did this already
    local a_index = 1
    while a_index <= helper.child_count(attacker.__cfg,"attack") do
	local weapon_temp = helper.get_nth_child(attacker.__cfg, "attack", a_index)
	if weapon_temp.name == "aa_khthon_enthrall_attack" then
		 weapon = a_index
	end
	a_index = a_index + 1
    end  

    AH.checked_attack(ai, attacker, defender, weapon)
    data.PU_best_attack = nil
end
                               
return ca_plague_attack                                                                                                  
