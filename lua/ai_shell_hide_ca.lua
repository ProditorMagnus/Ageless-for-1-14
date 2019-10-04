
local H = wesnoth.require "lua/helper.lua"
local AH = wesnoth.require "ai/lua/ai_helper.lua"

-----------------------------------------
-- hiding
-----------------------------------------
local ca_shell_hide = {}

function ca_shell_hide:evaluation(cfg)
	--wesnoth.message("evaluating")
-- start with two or more enemies, not level 0
-- this is a dumb function, need to improve
	local adj = wesnoth.get_units( { type = "AE_arc_Terrapin,AE_arc_Snapper,AE_arc_Tortoise,AE_arc_Rock Snapper,AE_arc_Rockback,AE_arc_Adamantine",
					 side = wesnoth.current.side,
					 { "filter_adjacent", 
					 	{
					 		count = "2,3,4,5,6",
					 		is_enemy = "yes",
							{ "not", { level = 0 }}
					 	}
					 }
					} )
	if #adj > 0 then
		return 150000
	else
		return 0
	end
end

function ca_shell_hide:execution(cfg)
	--wesnoth.message("executing")
	local indx = 0
	local adj = wesnoth.get_units( { type = "AE_arc_Terrapin,AE_arc_Snapper,AE_arc_Tortoise,AE_arc_Rock Snapper,AE_arc_Rockback,AE_arc_Adamantine",
					 side = wesnoth.current.side,
					 { "filter_adjacent", 
					 	{
					 		count = "2,3,4,5,6",
					 		is_enemy = "yes",
							{ "not", { level = 0 }}
					 	}
					 }
					} )
	if #adj == 0 then 
		return
	end

	while indx < #adj do
		indx = indx +1
		local hide_type = string.format("%s_Hiding", adj[indx].type)		
--	        wesnoth.message(hide_type)  
	        wesnoth.transform_unit(adj[indx], hide_type)    
	        wesnoth.fire("store_unit", { variable="my_unit", { "filter", { id = adj[indx].id } } })    
	        wesnoth.set_variable("my_unit.status.shell_hiding","yes")  
	        wesnoth.fire("unstore_unit", { variable="my_unit", find_vacant = "no"})  
	end
                                        	
end

return ca_shell_hide

