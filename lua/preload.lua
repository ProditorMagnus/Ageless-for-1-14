--<< 

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
	return wesnoth.have_file("~add-ons/DBG_Modification/_main.cfg")
end

function wesnoth.wml_conditionals.AE_beta()
	return wesnoth.wml_conditionals.Ravana() or AE_use_beta_features == "use_beta_features"
end

function wesnoth.wml_actions.AE_read_file(cfg)
	local V = wml.variables
	V[cfg.variable or "file"] = wesnoth.read_file(cfg.name)
end

function wesnoth.wml_actions.AE_dofile(cfg)
	wesnoth.dofile("~add-ons/Ageless_Era/lua/"..cfg.name)
end

-->>