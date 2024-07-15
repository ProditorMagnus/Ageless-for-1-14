#!/usr/bin/env python3
import os
from collections import defaultdict

replacements = [
	

	("rov_","AE_AoA_rovahr_"),
	("rel_","AE_AoA_rovelf_"),
	("emp_","AE_AoA_empfinn_"),
	("far_","AE_AoA_farengar_"),
	("fna_","AE_AoA_farnains_"),
	("fed_","AE_AoA_federation_"),
	("gal_","AE_AoA_galianos_"),
	("gob_","AE_AoA_gobmon_"),
	("mord_","AE_AoA_morkdarf_"),
	("nor_","AE_AoA_nordian_"),

	("empfinn_def","AE_AoA_side_empfinn"),
	("farengar_def","AE_AoA_side_farengar"),
	("farNains_def","AE_AoA_side_farnains"),
	("federation_def","AE_AoA_side_federation"),
	("galianos_def","AE_AoA_side_galianos"),
	("gobmon_def","AE_AoA_side_gobmon"),
	("MorkDarf_def","AE_AoA_side_morkdarf"),
	("nordian_def","AE_AoA_side_nordian"),
	("rovahr_def","AE_AoA_side_rovahr"),
	("rovhElfe_def","AE_AoA_side_rovelf"),

	("empfinn_aoh","AE_AoA_side_empfinn"),
	("farengar_aoh","AE_AoA_side_farengar"),
	("farNains_aoh","AE_AoA_side_farnains"),
	("federation_aoh","AE_AoA_side_federation"),
	("galianos_aoh","AE_AoA_side_galianos"),
	("gobmon_aoh","AE_AoA_side_gobmon"),
	("MorkDarf_aoh","AE_AoA_side_morkdarf"),
	("nordian_aoh","AE_AoA_side_nordian"),
	("rovahr_aoh","AE_AoA_side_rovahr"),
	("rovhElfe_aoh","AE_AoA_side_rovelf"),

	("""
    description= _ ""","""
    description={AE_AOA_UNIT_NOTICE}+ _ """),
	("""
    description=_ ""","""
    description={AE_AOA_UNIT_NOTICE}+ _ """),
	("""
    description=_""","""
    description={AE_AOA_UNIT_NOTICE}+ _ """),
	
	("__DUMMY__","__DUMMY__")
]

def getAgelessPath(dname, fname):
	if "factions" in dname:
		return os.path.join(".","Ageless_Era","factions","AoA",fname)
	if "units" in dname:
		basename = os.path.basename(dname)
		if basename == "units":
			basename = ""
		return os.path.join(".","Ageless_Era","units","AoA_units",basename,fname)
	if "data" in dname:
		return os.path.join(".","Ageless_Era","data","AoA_data",fname)
	raise Exception("Unhandled folder {}".format(dname))

eras = defaultdict(str)
for dname, dirs, files in os.walk("."):
	if "factions" not in dname and "units" not in dname and "data" not in dname:
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
			s = s.replace(find, replace)
		if "factions" in dname:
			s = s.replace('name=_"', 'name= _ "AoA - ')
			if "aoh" in fname:
				eras["heroes"] += s
				eras["heroes"] += "\n"
			elif "RPG" in fname:
				eras["RPG"] += s
				eras["RPG"] += "\n"
			elif "default" in fname:
				eras["default"] += s
				eras["default"] += "\n"
		else:
			os.makedirs(os.path.dirname(afpath), exist_ok=True)
			with open(afpath, "w", encoding="utf8") as f:
				f.write(s)

with open("Ageless_Era/units/AoA_units/units.cfg", "a", encoding="utf8") as f:
	f.write("""

{GET_AE_UNITS AoA_units/farengar}
{GET_AE_UNITS AoA_units/empire}
{GET_AE_UNITS AoA_units/federation}
{GET_AE_UNITS AoA_units/nord}
{GET_AE_UNITS AoA_units/rovahr}
{GET_AE_UNITS AoA_units/galianos}
{GET_AE_UNITS AoA_units/far_nains}
{GET_AE_UNITS AoA_units/mork-darf}
{GET_AE_UNITS AoA_units/gobmon}
{GET_AE_UNITS AoA_units/rov_elf}
""")

# factions to file
for era in eras:
	os.makedirs(os.path.dirname("Ageless_Era/factions/{}/".format(era)), exist_ok=True)
	with open("Ageless_Era/factions/{}/{}-AoA.cfg".format(era, era), "w", encoding="utf8") as f:
		f.write(eras[era])
