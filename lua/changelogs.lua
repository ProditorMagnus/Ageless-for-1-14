--<<

local T = wml.tag

local function lua(code)
    return T.lua {
        code = code
    }
end

local function short_changelog(version)
    return T.option {
        message = version .. " short changelog",
        T.command {
            T.lua {
                code = 'wesnoth.wml_actions.message{speaker="narrator", message=wesnoth.read_file("~add-ons/Ageless_Era/changelog/changelog-' .. version .. '.txt")}'
            },
            T.fire_event { name = "AE_show_changelog_menu" }
        }
    }
end

local function full_changelog(version)
    return T.option {
        message = version .. " full changelog",
        T.command {
            T.lua {
                code = 'wesnoth.wml_actions.message{speaker="narrator", message=wesnoth.read_file("~add-ons/Ageless_Era/changelog/changelog-' .. version .. '-unedited.txt")}'
            },
            T.fire_event { name = "AE_show_changelog_menu" }
        }
    }
end

local function changelog(version)
    return T.option {
        message = version .. " changelog",
        T.command {
            T.lua {
                code = 'wesnoth.wml_actions.message{speaker="narrator", message=wesnoth.read_file("~add-ons/Ageless_Era/changelog/changelog-' .. version .. '.txt")}'
            },
            T.fire_event { name = "AE_show_changelog_menu" }
        }
    }
end

local message = {
    speaker = "narrator",
    caption = "Ageless Era changelogs",
    T.option { message = "Return to game" },
    T.option {
        message = "Return to previous menu",
        T.command { T.fire_event { name = "AE_show_unsynced_menu" } }
    },
    T.option {
        message = "Latest short changelog",
        T.command {
            T.fire_event { name = "AE_show_changelog" },
            T.fire_event { name = "AE_show_changelog_menu" }
        }
    },
	changelog("4.37"),
	changelog("4.36"),
	changelog("4.35"),
	changelog("4.34"),
	changelog("4.33"),
	changelog("4.32"),
	changelog("4.31"),
	changelog("4.30"),
	changelog("4.29"),
	changelog("4.28"),
	changelog("4.27"),
    T.option {
        message = "4.27 balance changes (5 messages)",
        T.command {
            lua('wesnoth.wml_actions.message{speaker="narrator", message=wesnoth.read_file("~add-ons/Ageless_Era/changelog/4.27/a_balance_changes.txt")}'),
            lua('wesnoth.wml_actions.message{speaker="narrator", message=wesnoth.read_file("~add-ons/Ageless_Era/changelog/4.27/b_balance_changes.txt")}'),
            lua('wesnoth.wml_actions.message{speaker="narrator", message=wesnoth.read_file("~add-ons/Ageless_Era/changelog/4.27/c_balance_changes.txt")}'),
            lua('wesnoth.wml_actions.message{speaker="narrator", message=wesnoth.read_file("~add-ons/Ageless_Era/changelog/4.27/d_balance_changes.txt")}'),
            lua('wesnoth.wml_actions.message{speaker="narrator", message=wesnoth.read_file("~add-ons/Ageless_Era/changelog/4.27/e_balance_changes.txt")}'),
            T.fire_event { name = "AE_show_changelog_menu" }
        }
    },
    changelog("4.26"),
    T.option {
        message = "4.26 balance changes (4 messages)",
        T.command {
            lua('wesnoth.wml_actions.message{speaker="narrator", message=wesnoth.read_file("~add-ons/Ageless_Era/changelog/4.26/a_balance_changes.txt")}'),
            lua('wesnoth.wml_actions.message{speaker="narrator", message=wesnoth.read_file("~add-ons/Ageless_Era/changelog/4.26/b_balance_changes.txt")}'),
            lua('wesnoth.wml_actions.message{speaker="narrator", message=wesnoth.read_file("~add-ons/Ageless_Era/changelog/4.26/c_balance_changes.txt")}'),
            lua('wesnoth.wml_actions.message{speaker="narrator", message=wesnoth.read_file("~add-ons/Ageless_Era/changelog/4.26/d_balance_changes.txt")}'),
            T.fire_event { name = "AE_show_changelog_menu" }
        }
    },
    changelog("4.25"),
    T.option {
        message = "4.25 balance changes (3 messages)",
        T.command {
            lua('wesnoth.wml_actions.message{speaker="narrator", message=wesnoth.read_file("~add-ons/Ageless_Era/changelog/4.25/a_balance_changes.txt")}'),
            lua('wesnoth.wml_actions.message{speaker="narrator", message=wesnoth.read_file("~add-ons/Ageless_Era/changelog/4.25/b_balance_changes.txt")}'),
            lua('wesnoth.wml_actions.message{speaker="narrator", message=wesnoth.read_file("~add-ons/Ageless_Era/changelog/4.25/c_balance_changes.txt")}'),
            T.fire_event { name = "AE_show_changelog_menu" }
        }
    },
    changelog("4.24"),
    changelog("4.23"),
    changelog("4.22"),
    changelog("4.21"),
    changelog("4.20"),
    short_changelog("4.19"),
    T.option {
        message = "4.19 full changelog (split into 2 messages)",
        T.command {
            lua('wesnoth.wml_actions.message{speaker="narrator", message=wesnoth.read_file("~add-ons/Ageless_Era/changelog/changelog-4.19-unedited.txt")}'),
            lua('wesnoth.wml_actions.message{speaker="narrator", caption="EFM balance", message=wesnoth.read_file("~add-ons/Ageless_Era/changelog/4.19/xara_changelog.txt")}'),
            T.fire_event { name = "AE_show_changelog_menu" }
        }
    },
    short_changelog("4.18"),
    T.option {
        message = "4.18 full changelog (split into 7 messages)",
        T.command {
            lua('wesnoth.wml_actions.message{speaker="narrator", message=wesnoth.read_file("~add-ons/Ageless_Era/changelog/changelog-4.18-unedited.txt")}'),
            lua('wesnoth.wml_actions.message{speaker="narrator", caption="Balance note 1 by IPS", message=wesnoth.read_file("~add-ons/Ageless_Era/changelog/4.18/Ageless_changes_part_1.txt")}'),
            lua('wesnoth.wml_actions.message{speaker="narrator", caption="Balance note 2 by IPS", message=wesnoth.read_file("~add-ons/Ageless_Era/changelog/4.18/Ageless_changes_part_2.txt")}'),
            lua('wesnoth.wml_actions.message{speaker="narrator", caption="Balance note 3 by IPS", message=wesnoth.read_file("~add-ons/Ageless_Era/changelog/4.18/Ageless_changes_part_3.txt")}'),
            lua('wesnoth.wml_actions.message{speaker="narrator", caption="Balance note 4 by IPS", message=wesnoth.read_file("~add-ons/Ageless_Era/changelog/4.18/Ageless_changes_part_4.txt")}'),
            lua('wesnoth.wml_actions.message{speaker="narrator", caption="Balance note 5 by IPS", message=wesnoth.read_file("~add-ons/Ageless_Era/changelog/4.18/Ageless_changes_part_5.txt")}'),
            lua('wesnoth.wml_actions.message{speaker="narrator", caption="Balance note 6 by IPS", message=wesnoth.read_file("~add-ons/Ageless_Era/changelog/4.18/Ageless_changes_part_6.txt")}'),
            T.fire_event { name = "AE_show_changelog_menu" }
        }
    },
    short_changelog("4.17"),
    T.option {
        message = "4.17 full changelog (split into 3 messages)",
        T.command {
            lua('wesnoth.wml_actions.message{speaker="narrator", message=wesnoth.read_file("~add-ons/Ageless_Era/changelog/changelog-4.17-unedited.txt")}'),
            lua('wesnoth.wml_actions.message{speaker="narrator", caption="Balance note 1 by IPS", message=wesnoth.read_file("~add-ons/Ageless_Era/changelog/4.17/balance_note_1.txt")}'),
            lua('wesnoth.wml_actions.message{speaker="narrator", caption="Mercs hotfix by IPS", message=wesnoth.read_file("~add-ons/Ageless_Era/changelog/4.17/mercs_hotfix.txt")}'),
            T.fire_event { name = "AE_show_changelog_menu" }
        }
    },
    short_changelog("4.16"),
    full_changelog("4.16"),
    short_changelog("4.15"),
    full_changelog("4.15"),
    short_changelog("4.14"),
    full_changelog("4.14"),
    short_changelog("4.13"),
    full_changelog("4.13"),
    changelog("4.12.1"),
    short_changelog("4.12"),
    full_changelog("4.12"),
    changelog("4.11.1"),
    short_changelog("4.11"),
    full_changelog("4.11"),
    changelog("4.10"),
    changelog("4.9"),
    changelog("4.8"),
    changelog("4.7"),
    changelog("4.6"),
    T.option { message = "Return to game" }
}

-- table.insert(message, T.option{message="Return to game"})
wesnoth.wml_actions.message(message)

-->>
