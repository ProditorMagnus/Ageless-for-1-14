local H = wesnoth.require "lua/helper.lua"
local LS = wesnoth.require "lua/location_set.lua"



local aa_ai_helper = {}


function aa_ai_helper.has_weapon_special(unit, special_tag, special_id)
    -- Returns true/false depending on whether @unit has a weapon with special @special
    -- like the core ai_helper function of similar name, but instead of returning the tag name, like [damage],
    -- it finds the ID.
    -- Also returns the number of the first weapon with this special
    local weapon_number = 0
    for att in H.child_range(unit.__cfg, 'attack') do
        weapon_number = weapon_number + 1
        for sp in H.child_range(att, 'specials') do
               if H.get_child(sp, special_tag, special_id) then
                               return true, weapon_number
               end
        end
    end
    return false
end

function aa_ai_helper.get_attacks(units, cfg)
    -- --this is exactly like the similar core ai_helper function, but it 
    -- -- takes attacker weapon index as an argument
    -- Get all attacks the units stored in @units can do
    -- This includes a variety of configurable options, passed in the @cfg
    -- table
    -- @cfg: table with config parameters
    --  weapon_index: the weapon index (1,2,3 ...) used to simulate combat
    --  moves: "current" (default for units on current side) or "max"
    -- (always used for units on other sides)
    --  include_occupied (false): if set, also include hexes occupied by
    -- own-side units that can move away
    --  simulate_combat (false): if set, also simulate the combat and return
    -- result (this is slow; only set if needed)

    -- Returns {} if no attacks can be done, otherwise table with fields:
    --   dst: { x = x, y = y } of attack position
    --   src: { x = x, y = y } of attacking unit (don't use id, could be
    -- ambiguous)
    --   target: { x = x, y = y } of defending unit
    --   att_stats, def_stats: as returned by wesnoth.simulate_combat (if
    -- cfg.simulate_combat is set)
    -- --  att_weapon, def_weapon: as returned by wesnoth.simulate_combat (if
    -- --cfg.simulate_combat is set)
    --   attack_hex_occupied: boolean storing whether an own unit that can
    -- move away is on the attack hex

    cfg = cfg or {}

    local attacks = {}
    if (not units[1]) then return attacks end

    local side = units[1].side  -- all units need to be on same side

    -- 'moves' can be either "current" or "max"
    -- For unit on current side: use "current" by default, or override by
    -- cfg.moves
    local moves = cfg.moves or "current"
    -- For unit on any other side, only moves="max" makes sense
    if (side ~= wesnoth.current.side) then moves = "max" end

    local old_moves = {}
    if (moves == "max") then
        for i,unit in ipairs(units) do
            old_moves[i] = unit.moves
            unit.moves = unit.max_moves
        end
    end

    -- Note: the remainder is optimized for speed, so we only get_units
    -- once,
    -- do not use WML filters, etc.
    local all_units = wesnoth.get_units()

    local enemy_map, my_unit_map, other_unit_map = LS.create(), LS.create(), LS.create()
    for i,unit in ipairs(all_units) do
        -- The value of all the location sets is the index of the
        -- unit in the all_units array
        if wesnoth.is_enemy(unit.side, side) and (not unit.status.petrified) then
            enemy_map:insert(unit.x, unit.y, i)
        end

        if (unit.side == side) then
            my_unit_map:insert(unit.x, unit.y, i)
        else
            other_unit_map:insert(unit.x, unit.y, i)
        end
    end

    local attack_hex_map = LS.create()
    enemy_map:iter(function(e_x, e_y, i)
        for xa,ya in H.adjacent_tiles(e_x, e_y) do
            -- If there's no unit of another side on this hex, include it
            -- as possible attack location (this includes hexes occupied
            -- by own units at this time)
            if (not other_unit_map:get(xa, ya)) then
                local target_table = attack_hex_map:get(xa, ya) or {}
                table.insert(target_table, { x = e_x, y = e_y, i = i })
                attack_hex_map:insert(xa, ya, target_table)
            end
        end
    end)

    -- The following is done so that we at most need to do find_reach() once
    -- per unit
    -- It is needed for all units in @units and for testing whether units
    -- can move out of the way
    local reaches = LS.create()

    for _,unit in ipairs(units) do
        local reach
        if reaches:get(unit.x, unit.y) then
            reach = reaches:get(unit.x, unit.y)
        else
            reach = wesnoth.find_reach(unit)
            reaches:insert(unit.x, unit.y, reach)
        end

        for _,loc in ipairs(reach) do
            if attack_hex_map:get(loc[1], loc[2]) then
                local add_target = true
                local attack_hex_occupied = false

                -- If another unit of same side is on this hex:
                if my_unit_map:get(loc[1], loc[2]) and ((loc[1] ~= unit.x) or (loc[2] ~= unit.y)) then
                    attack_hex_occupied = true
                    add_target = false

                    if cfg.include_occupied then -- Test whether it can move out of the way
                        local unit_in_way = all_units[my_unit_map:get(loc[1], loc[2])]
                        local uiw_reach
                        if reaches:get(unit_in_way.x, unit_in_way.y) then
                            uiw_reach = reaches:get(unit_in_way.x, unit_in_way.y)
                        else
                            uiw_reach = wesnoth.find_reach(unit_in_way)
                            reaches:insert(unit_in_way.x, unit_in_way.y, uiw_reach)
                        end

                        -- Check whether the unit to move out of the way has
                        -- an unoccupied hex to move to.
                        -- We do not deal with cases where a unit can move
                        -- out of the way for a
                        -- unit that is moving out of the way of the initial
                        -- unit (etc.).
                        for _,uiw_loc in ipairs(uiw_reach) do
                            -- Unit in the way of the unit in the way
                            local uiw_uiw = wesnoth.get_unit(uiw_loc[1], uiw_loc[2])
                            if (not uiw_uiw) then
                                add_target = true
                                break
                            end
                        end
                    end
                end

                if add_target then
                    for _,target in ipairs(attack_hex_map:get(loc[1], loc[2])) do
                        local att_stats, def_stats
                        local att_weapon, def_weapon
                        if cfg.simulate_combat then
                            local unit_dst = wesnoth.copy_unit(unit)
                            unit_dst.x, unit_dst.y = loc[1], loc[2]

                            local enemy = all_units[target.i]
			    local weapon_index = 1 -- default to first attack, since I'm not sure if '-1' is supported for simulate_combat()
			    if cfg.weapon_id then
				    local a_index = 1
				    while a_index <= H.child_count(unit_dst.__cfg,"attack") do
        				local weapon_temp = H.get_nth_child(unit_dst.__cfg, "attack", a_index)
                			if weapon_temp.name == cfg.weapon_id then
                                 		weapon_index = a_index
                                        end
                                        a_index = a_index + 1
                                    end  
--			    	weapon_index = cfg.weapon_index
                                att_stats, def_stats, att_weapon, def_weapon = wesnoth.simulate_combat(unit_dst, weapon_index, enemy)
                            else
                                att_stats, def_stats, att_weapon, def_weapon = wesnoth.simulate_combat(unit_dst, enemy)
			    end
                        end

                        table.insert(attacks, {
                            src = { x = unit.x, y = unit.y },
                            dst = { x = loc[1], y = loc[2] },
                            target = { x = target.x, y = target.y },
                            att_stats = att_stats,
                            def_stats = def_stats,
                            att_weapon = att_weapon,
                            def_weapon = def_weapon,
                            attack_hex_occupied = attack_hex_occupied
                        })
                    end
                end
            end
        end
    end

    if (moves == "max") then
        for i,unit in ipairs(units) do
            unit.moves = old_moves[i]
        end
    end

    return attacks
end



return aa_ai_helper

