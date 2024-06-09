--<<

local T = wml.tag
local function sign(x)
	if x > 0 then return 1 end
	return -1
end
local abs=math.abs

function wesnoth.wml_conditionals.AE_mag_is_unbalanced()
	local id = tostring((wesnoth.scenario.era or {id=""}).id)
	id = id:lower()
	if id:find("unbalanced") then
		return true
	else
		return false
	end
end

function wesnoth.wml_conditionals.AE_mag_not_unbalanced()
	return not wesnoth.wml_conditionals.AE_mag_is_unbalanced()
end

function wesnoth.wml_conditionals.AE_mag_is_masters()
	local id = tostring((wesnoth.scenario.era or {id=""}).id)
	id = id:lower()
	if id:find("masters") then
		return true
	else
		return false
	end
end

function wesnoth.wml_conditionals.AE_mag_not_masters()
	return not wesnoth.wml_conditionals.AE_mag_is_masters()
end

function wesnoth.wml_conditionals.AE_is_rpg()
	local id = tostring((wesnoth.scenario.era or {id=""}).id)
	id = id:lower()
	if id:find("rpg") then
		return true
	else
		return false
	end
end

function wesnoth.wml_conditionals.AE_not_rpg()
	return not wesnoth.wml_conditionals.AE_is_rpg()
end

function wesnoth.wml_conditionals.AE_is_observer()
	local all_sides = wesnoth.get_sides()
	for index, side in ipairs(all_sides) do
		if side.controller == "human" and side.is_local then
			return false
		end
	end
	return true
end

function wesnoth.wml_conditionals.AE_is_active()
	return wesnoth.sides[wesnoth.current.side].controller == "human" and wesnoth.sides[wesnoth.current.side].is_local
end

function wesnoth.wml_conditionals.AE_not_active()
	return wesnoth.wml_conditionals.AE_is_observer() or not wesnoth.wml_conditionals.AE_is_active()
end

function wesnoth.wml_conditionals.Ravana()
	return filesystem.have_file("~add-ons/DBG_Modification/_main.cfg")
end

function wesnoth.wml_actions.AE_read_file(cfg)
	local V = wml.variables
	V[cfg.variable or "file"] = wesnoth.read_file(cfg.name)
end

function wesnoth.wml_actions.AE_dofile(cfg)
	wesnoth.dofile("~add-ons/Ageless_Era/lua/"..cfg.name)
end

function wesnoth.wml_actions.AE_efm_add_hex(cfg)
	local max_cth = 90
	local def_redu = 15
	local function map_def(defense)
		if not defense then return 100 end
		if abs(defense) > max_cth then return defense end
		if abs(defense) > (max_cth-def_redu) then return sign(defense)*max_cth end
		return sign(defense)*(abs(defense)+def_redu)
	end

	local units = wesnoth.get_units(cfg)
	for _,u in pairs(units) do
		local def = wml.get_child(u.__cfg, "defense") or error("need-check-nil")

		u:add_modification("object",{
			id="AE_efm_hex_object",
			T.effect{
				apply_to="defense",
				replace=true,
				T.defense{
					deep_water=map_def(def["deep_water"]),
					shallow_water=map_def(def["shallow_water"]),
					reef=map_def(def["reef"]),
					swamp_water=map_def(def["swamp_water"]),
					flat=map_def(def["flat"]),
					sand=map_def(def["sand"]),
					forest=map_def(def["forest"]),
					hills=map_def(def["hills"]),
					mountains=map_def(def["mountains"]),
					village=map_def(def["village"]),
					castle=map_def(def["castle"]),
					cave=map_def(def["cave"]),
					frozen=map_def(def["frozen"]),
					unwalkable=map_def(def["unwalkable"]),
					impassable=map_def(def["impassable"]),
					fungus=map_def(def["fungus"])
				}
			},
			T.effect{
				apply_to="overlay",
				add="utils/curse.png"
			}
		})
		u.status.AE_efm_curse = true
	end
end

function wesnoth.wml_actions.AE_efm_remove_hex(cfg)
	local units = wesnoth.get_units(cfg)
	for i,u in ipairs(units) do
		u:remove_modifications({id="AE_efm_hex_object"})
		wesnoth.wml_actions.remove_unit_overlay{id=u.id, image="utils/curse.png"}
		u.status.AE_efm_curse = false
	end
end

function wesnoth.wml_actions.AE_efm_shift_unit(cfg)
	local bear_contains = {"F","Uf","Uu","Uh","Aa^"}
	local human_contains = {"K","C","Vh","Ve"}
	local beaver_contains = {"W","w","Ss"}
	local boar_contains = {"D","Gg","Re","Rp","Gs","Re","Rd","Rr","Dd","Hd","Ur"}
	local wolf_contains = {"A","Ha"}
	local goat_contains = {"H","M","Dd^Dr"}
	-- else human
	local function get_variation(terrain)
		for _, t in pairs(bear_contains) do
			if terrain:find(t) then return "shifter_bear" end
		end
		for _, t in pairs(human_contains) do
			if terrain:find(t) then return "shifter_human" end
		end
		for _, t in pairs(beaver_contains) do
			if terrain:find(t) then return "shifter_beaver" end
		end
		for _, t in pairs(boar_contains) do
			if terrain:find(t) then return "shifter_warthog" end
		end
		for _, t in pairs(wolf_contains) do
			if terrain:find(t) then return "shifter_wolf" end
		end
		for _, t in pairs(goat_contains) do
			if terrain:find(t) then return "shifter_goat" end
		end
		return "shifter_human"
	end

	local units = wesnoth.get_units(cfg)
	for i,u in ipairs(units) do
		u:remove_modifications({id="AE_efm_shift_object"})
		local variation = get_variation(wesnoth.get_terrain(u.x, u.y))
		u:add_modification("object",{
			id="AE_efm_shift_object",
			T.effect{
				apply_to="variation",
				name=variation
			}
		})
	end
end

function wesnoth.wml_actions.AE_mag_remove_array_duplicates(cfg)
	local name = tostring(cfg.name)
	local attribute = cfg.attribute

	local values = {}
	local inArray = wml.array_access.get(name)
	local outArray = {}
	for _, u in pairs(inArray) do
		if values[u[attribute]] then
			-- skip duplicate
		else
			values[u[attribute]] = true
			table.insert(outArray, u)
		end
	end
	wml.array_access.set(name, outArray)
end

function wesnoth.wml_actions.AE_mag_remember_indirectly_damaged_unit(cfg)
	wesnoth.wml_actions.store_unit{
		T.filter{
			x=cfg.x,
			y=cfg.y
		},
		variable="AE_mag_indirectly_damaged_unit",
		mode="append"
	}
end

function wesnoth.wml_actions.AE_mag_trigger_pain_absorbation_aura_on_location(cfg)
	local damaged_unit = wml.array_access.get("AE_mag_indirectly_damaged_unit")[#wml.array_access.get("AE_mag_indirectly_damaged_unit")]

	if damaged_unit.x ~= cfg.x or damaged_unit.y ~= cfg.y then
		AE_mag_debug_validation(damaged_unit.x, cfg.x, "AE_mag_trigger_pain_absorbation_aura_on_location should be triggered on most recently damaged unit, AE_mag_indirectly_damaged_unit x")
		AE_mag_debug_validation(damaged_unit.y, cfg.y, "AE_mag_trigger_pain_absorbation_aura_on_location should be triggered on most recently damaged unit, AE_mag_indirectly_damaged_unit y")
		return
	end

	if not wml.get_child(damaged_unit, "status").undrainable then
		-- purpose of primary_unit is for middle level pain absorbation to only heal if area damage is caused by that same unit
		wesnoth.wml_actions.fire_event{
			name="AE_mag_pain_absorbation_aura",
			T.primary_weapon{
				x=cfg.x,
				y=cfg.y
			},
			T.primary_unit{
				id=cfg.primary_unit
			}
		}
	else
		-- print("debug AE_mag_trigger_pain_absorbation_aura_on_location skipped for undrainable unit "..damaged_unit.type)
	end
end

function AE_mag_debug_validation(actual, expected, description)
	-- extra validation/logging enabled if Era_of_Magic/modificationUnitTest.lua is loaded
	if rawget(_G, "AE_mag_assert_equal") ~= nil then
		-- intentially EoMa_ instead of AE_mag_
		---@diagnostic disable-next-line: undefined-global
		EoMa_assert_equal(actual, expected, description)
	end
end

function wesnoth.wml_actions.AE_give_fight_xp(cfg)
	local attacker_variable = cfg.attacker or "unit"
	local defender_variable = cfg.defender or "second_unit"

	local get_xp_to_give = function(unit_variable)
		local xp_result = 0
		if wml.variables[unit_variable..".hitpoints"] <= 0 then
			xp_result = wml.variables[unit_variable..".level"] * wesnoth.game_config.kill_experience
			if xp_result == 0 then
				xp_result = wesnoth.game_config.kill_experience * 0.5
			end
		else
			xp_result = wml.variables[unit_variable..".level"] * wesnoth.game_config.combat_experience
		end
		return xp_result
	end

	local attacker = wesnoth.units.get(tostring(wml.variables[attacker_variable..".id"]))
	local defender = wesnoth.units.get(tostring(wml.variables[defender_variable..".id"]))

	if cfg.attacker_xp ~= false and attacker ~= nil then
		attacker.experience = attacker.experience + get_xp_to_give(defender_variable)
	end

	if cfg.defender_xp ~= false and defender ~= nil then
		defender.experience = defender.experience + get_xp_to_give(attacker_variable)
	end
end

-->>
