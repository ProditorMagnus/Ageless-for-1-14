#!/usr/bin/env python3
import os
from collections import defaultdict

replacements = [
	

	#("FL_","AE_FGTN_"),
	#("_FL","_AE_FGTN_"),
	# needs manual review
	#("FL","AE_FGTNL_"),
	
	# incorrect replacements
	("MUZZLE_AE_FGTN_","MUZZLE_FL"),
	("~AE_FGTNL_","~FL"),
	

	("""
    description= _ ""","""
    description={AE_FGTNL_UNIT_NOTICE}+ _ """),
	("""
    description=_ ""","""
    description={AE_FGTNL_UNIT_NOTICE}+ _ """),
	("""
    description=_""","""
    description={AE_FGTNL_UNIT_NOTICE}+ _ """),
	
	("__DUMMY__","__DUMMY__")
]

def getAgelessPath(dname, fname):
	if "factions" in dname:
		return os.path.join(".","Ageless_Era","factions","FgtnL",fname)
	if "units" in dname:
		basename = os.path.basename(dname)
		if basename == "units":
			basename = ""
		return os.path.join(".","Ageless_Era","units","FgtnL_units",basename,fname)
	if "macros" in dname:
		return os.path.join(".","Ageless_Era","data","FgtnL_data",fname)
	raise Exception("Unhandled folder {}".format(dname))

eras = defaultdict(str)
for dname, dirs, files in os.walk("."):
	if "factions" not in dname and "units" not in dname and "macros" not in dname:
		continue
	if "Ageless_Era" in dname:
		continue
	if "Forgotten_Legends_Rebalanced" in dname:
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
			s = s.replace('name= _ "', 'name= _ "FgtnL - ')
			if "Heroes" in fname:
				eras["heroes"] += s
				eras["heroes"] += "\n"
			elif "RPG" in fname:
				eras["RPG"] += s
				eras["RPG"] += "\n"
			else:
				eras["default"] += s
				eras["default"] += "\n"
		else:
			os.makedirs(os.path.dirname(afpath), exist_ok=True)
			with open(afpath, "w", encoding="utf8") as f:
				f.write(s)

with open("Ageless_Era/units/FgtnL_units/units.cfg", "a", encoding="utf8") as f:
	f.write("""

{GET_AE_UNITS FgtnL_units/frakcja1}
{GET_AE_UNITS FgtnL_units/frakcja2}
{GET_AE_UNITS FgtnL_units/frakcja3}
{GET_AE_UNITS FgtnL_units/frakcja4}
{GET_AE_UNITS FgtnL_units/frakcja5}
""")

# factions to file
for era in eras:
	os.makedirs(os.path.dirname("Ageless_Era/factions/{}/".format(era)), exist_ok=True)
	with open("Ageless_Era/factions/{}/{}-FgtnL.cfg".format(era, era), "w", encoding="utf8") as f:
		f.write(eras[era])
