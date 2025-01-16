#!/usr/bin/env python3
import os
from collections import defaultdict
from collectRashyUnitIdReplacements import get_unit_type_mapping

replacements = [
	('{~add-ons/Rashy_Era/','{~ERROR_RE_ABSOLUTE_PATH/'),

	(' description=_"axe"',' description={STR_AXE}'),
	(' description=_"ballista"',' description={STR_BALLISTA}'),
	(' description=_"battle axe"',' description={STR_BATTLE_AXE}'),
	(' description=_"beak"',' description={STR_BEAK}'),
	(' description=_"bite"',' description={STR_BITE}'),
	(' description=_"bolas"',' description={STR_BOLAS}'),
	(' description=_"bow"',' description={STR_BOW}'),
	(' description=_"chill tempest"',' description={STR_CHILL_TEMPEST}'),
	(' description=_"chill wave"',' description={STR_CHILL_WAVE}'),
	(' description=_"claws"',' description={STR_CLAWS}'),
	(' description=_"cleaver"',' description={STR_CLEAVER}'),
	(' description=_"club"',' description={STR_CLUB}'),
	(' description=_"crossbow"',' description={STR_CROSSBOW}'),
	(' description=_"crush"',' description={STR_CRUSH}'),
	(' description=_"curse"',' description={STR_CURSE}'),
	(' description=_"dagger"',' description={STR_DAGGER}'),
	(' description=_"ensnare"',' description={STR_ENSNARE}'),
	(' description=_"entangle"',' description={STR_ENTANGLE}'),
	(' description=_"faerie fire"',' description={STR_FAERIE_FIRE}'),
	(' description=_"fangs"',' description={STR_FANGS}'),
	(' description=_"fireball"',' description={STR_FIREBALL}'),
	(' description=_"fist"',' description={STR_FIST}'),
	(' description=_"flail"',' description={STR_FLAIL}'),
	(' description=_"greatsword"',' description={STR_GREATSWORD}'),
	(' description=_"halberd"',' description={STR_HALBERD}'),
	(' description=_"hammer"',' description={STR_HAMMER}'),
	(' description=_"hatchet"',' description={STR_HATCHET}'),
	(' description=_"javelin"',' description={STR_JAVELIN}'),
	(' description=_"knife"',' description={STR_KNIFE}'),
	(' description=_"lance"',' description={STR_LANCE}'),
	(' description=_"lightbeam"',' description={STR_LIGHTBEAM}'),
	(' description=_"lightning"',' description={STR_LIGHTNING}'),
	(' description=_"longbow"',' description={STR_LONGBOW}'),
	(' description=_"longsword"',' description={STR_LONGSWORD}'),
	(' description=_"mace"',' description={STR_MACE}'),
	(' description=_"missile"',' description={STR_MISSILE}'),
	(' description=_"mud glob"',' description={STR_MUD_GLOB}'),
	(' description=_"net"',' description={STR_NET}'),
	(' description=_"pike"',' description={STR_PIKE}'),
	(' description=_"pitchfork"',' description={STR_PITCHFORK}'),
	(' description=_"plague staff"',' description={STR_PLAGUE_STAFF}'),
	(' description=_"ram"',' description={STR_RAM}'),
	(' description=_"saber"',' description={STR_SABER}'),
	(' description=_"scepter"',' description={STR_SCEPTER}'),
	(' description=_"shadow bolt"',' description={STR_SHADOW_BOLT}'),
	(' description=_"shadow wave"',' description={STR_SHADOW_WAVE}'),
	(' description=_"shield bash"',' description={STR_SHIELD_BASH}'),
	(' description=_"short sword"',' description={STR_SHORT_SWORD}'),
	(' description=_"sling"',' description={STR_SLING}'),
	(' description=_"spear"',' description={STR_SPEAR}'),
	(' description=_"staff"',' description={STR_STAFF}'),
	(' description=_"sword"',' description={STR_SWORD}'),
	(' description=_"tail"',' description={STR_TAIL}'),
	(' description=_"thorns"',' description={STR_THORNS}'),
	(' description=_"throwing knives"',' description={STR_THROWING_KNIVES}'),
	(' description=_"torch"',' description={STR_TORCH}'),
	(' description=_"touch"',' description={STR_TOUCH}'),
	(' description=_"trample"',' description={STR_TRAMPLE}'),
	(' description=_"trident"',' description={STR_TRIDENT}'),
	(' description=_"wail"',' description={STR_WAIL}'),
	(' description=_"water spray"',' description={STR_WATER_SPRAY}'),
	(' description=_"web"',' description={STR_WEB}'),

	("VRAq Warrior_Swordman", "AE_rhy_aq_Warrior_Swordsman"),
	(",VRAq Warrior,", ",AE_rhy_aq_Warrior_Swordsman,"),
	("units/undead/ghost", "units/{GHOST_IMAGE_FOLDER}/ghost"),
	("units/undead/nightgaunt", "units/{GHOST_IMAGE_FOLDER}/nightgaunt"),
	("units/undead/shadow", "units/{GHOST_IMAGE_FOLDER}/shadow"),
	("units/undead/spectre", "units/{GHOST_IMAGE_FOLDER}/spectre"),
	("units/undead/wraith", "units/{GHOST_IMAGE_FOLDER}/wraith"),
	("units/undead-spirit/ghost", "units/{GHOST_IMAGE_FOLDER}/ghost"),
	("units/undead-spirit/nightgaunt", "units/{GHOST_IMAGE_FOLDER}/nightgaunt"),
	("units/undead-spirit/shadow", "units/{GHOST_IMAGE_FOLDER}/shadow"),
	("units/undead-spirit/spectre", "units/{GHOST_IMAGE_FOLDER}/spectre"),
	("units/undead-spirit/wraith", "units/{GHOST_IMAGE_FOLDER}/wraith"),
	("VR_", "AE_RHY_"),
	("vr-", "AE_rhy_"),

	("""
    description= _ ""","""
    description={AE_RHY_UNIT_NOTICE}+ _ """),
	("""
	description= _ ""","""
    description={AE_RHY_UNIT_NOTICE}+ _ """),
	("""
    description=_ ""","""
    description={AE_RHY_UNIT_NOTICE}+ _ """),
	("""
	description=_ ""","""
    description={AE_RHY_UNIT_NOTICE}+ _ """),
	("""
    description=_""","""
    description={AE_RHY_UNIT_NOTICE}+ _ """),
	("""
	description=_""","""
    description={AE_RHY_UNIT_NOTICE}+ _ """),
	("""
    description={NO_DESCR_AVAILABLE}""","""
    description={AE_RHY_UNIT_NOTICE}+{NO_DESCR_AVAILABLE}"""),
	("__DUMMY__","__DUMMY__")
]

unit_type_mapping = get_unit_type_mapping()
for k in sorted(unit_type_mapping, key=lambda x: -len(x)):
	replacements.append((k, unit_type_mapping[k]))



def getAgelessPath(dname, fname):
	if "factions" in dname:
		return os.path.join(".","Ageless_Era","factions","RE",fname)
	if "units" in dname:
		basename = os.path.basename(dname)
		if basename == "units":
			basename = ""
		return os.path.join(".","Ageless_Era","units","RE_units",basename,fname)
	if "macros" in dname:
		return os.path.join(".","Ageless_Era","data","RE_data",fname)
	raise Exception("Unhandled folder {}".format(dname))

eras = defaultdict(str)
for dname, dirs, files in os.walk("."):
	if "factions" not in dname and "units" not in dname and "macros" not in dname:
		continue
	if "Ageless_Era" in dname or "images" in dname:
		continue
	print(dname)
	for fname in files:
		fpath = os.path.join(dname, fname)
		afpath = getAgelessPath(dname, fname)
		# print(fpath, afpath)
		with open(fpath,encoding="utf8") as f:
			s = f.read()
		for (find, replace) in replacements:
			if "description={STR_" in replace:
				s = s.replace(find.replace('description=_"','description= _"'), replace)
				s = s.replace(find.replace('description=_"','description=_ "'), replace)
				s = s.replace(find.replace('description=_"','description= _ "'), replace)
			s = s.replace(find, replace)
		if "factions" in dname:
			s = s.replace("{AE_RHY_UNIT_NOTICE}+", "")
			s = s.replace('name= _"', 'name= "RE - " + _"')
			s = s.replace('name=_"', 'name= "RE - " + _"')
			if "default" in fname:
				eras["default"] += s
				eras["default"] += "\n"
			elif "aoh" in fname:
				eras["heroes"] += s
				eras["heroes"] += "\n"
			elif "mrpg" in fname:
				eras["RPG"] += s
				eras["RPG"] += "\n"
			# TODO no rpg era
		else:
			os.makedirs(os.path.dirname(afpath), exist_ok=True)
			with open(afpath, "w", encoding="utf8") as f:
				f.write(s)

if eras["RPG"] == "":
	rpg_era = ""
	for line in eras["default"].split("\n"):
		if "type=" in line or "leader=" in line or "ai]" in line or "recruitment_pattern=" in line:
			continue
		line = line.replace("recruit=","leader=")
		line = line.replace(",Vampire Bat","")
		rpg_era += line + "\n"
	eras["RPG"] = rpg_era

with open("Ageless_Era/units/RE_units/units.cfg", "a", encoding="utf8") as f:
	f.write("""

{GET_AE_UNITS RE_units/aquana}
{GET_AE_UNITS RE_units/dwarves}
{GET_AE_UNITS RE_units/elves-dark}
{GET_AE_UNITS RE_units/elyser}
{GET_AE_UNITS RE_units/gnomes}
{GET_AE_UNITS RE_units/human-chevalier}
{GET_AE_UNITS RE_units/human-dardo}
{GET_AE_UNITS RE_units/human-forest}
{GET_AE_UNITS RE_units/human-luz}
{GET_AE_UNITS RE_units/human-mountain}
{GET_AE_UNITS RE_units/human-regis}
{GET_AE_UNITS RE_units/marashy}
{GET_AE_UNITS RE_units/ships}
{GET_AE_UNITS RE_units/trarashy}
{GET_AE_UNITS RE_units/undead}
{GET_AE_UNITS RE_units/vixens}
""")

# factions to file
for era in eras:
	os.makedirs(os.path.dirname("Ageless_Era/factions/{}/".format(era)), exist_ok=True)
	with open("Ageless_Era/factions/{}/{}-RE.cfg".format(era, era), "w", encoding="utf8") as f:
		f.write(eras[era])
