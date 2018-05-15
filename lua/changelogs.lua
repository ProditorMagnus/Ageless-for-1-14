--<< 

local T = wml.tag

local message = {
	speaker="narrator",
	caption="Ageless Era changelogs",
	T.option{
		message="Return to previous menu",
		T.command{T.fire_event{name="AE_show_unsynced_menu"}}
	},
	T.option{
		message="Latest short changelog",
		T.command{
			T.fire_event{name="AE_show_changelog"},
			T.fire_event{name="AE_show_changelog_menu"}
		}
	},
	T.option{message="Return to game"}
}

table.insert(message, T.option{message="Return to game"})
wesnoth.wml_actions.message(message)

-->>