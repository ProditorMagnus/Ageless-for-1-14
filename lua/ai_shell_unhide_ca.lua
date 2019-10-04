--- Make a CA that triggers the action for the AI

local H = wesnoth.require "lua/helper.lua"
local AH = wesnoth.require "ai/lua/ai_helper.lua"

-----------------------------------------
-- unhiding
-----------------------------------------
local ca_shell_unhide = {}

function ca_shell_unhide:evaluation(cfg)
	--wesnoth.message("evaluating")
-- start with two or more enemies, not level 0
-- this is a dumb function, need to improve
	local adj = wesnoth.get_units( { status = "shell_hiding",
					 side = wesnoth.current.side,
					 { "filter_adjacent", 
					 	{
					 		count = "0,1",
					 		is_enemy = "yes",
							{ "not", { level = 0 }}
					 	}
					 }
					} )
	if #adj > 0 then
		return 140000
	else
		return 0
	end
end

function ca_shell_unhide:execution(cfg)
	--wesnoth.message("executing")
	local indx = 0
	local adj = wesnoth.get_units( { status = "shell_hiding",
					 side = wesnoth.current.side,
					 { "filter_adjacent", 
					 	{
					 		count = "0,1",
					 		is_enemy = "yes",
							{ "not", { level = 0 }}
					 	}
					 }
					} )
	if #adj == 0 then 
		return
	end

	while indx < #adj do
		indx = indx + 1
		local unhide_type = string.sub(adj[indx].type,1,-8)
--		wesnoth.message(unhide_type)
		wesnoth.transform_unit(adj[indx], unhide_type)
		wesnoth.fire("store_unit", { variable="my_unit", { "filter", { id = adj[indx].id } } })	
		wesnoth.set_variable("my_unit.status.shell_hiding","no")
		wesnoth.fire("unstore_unit", { variable="my_unit", find_vacant = "no"})
	end

end

return ca_shell_unhide

