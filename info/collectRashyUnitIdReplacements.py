#!/usr/bin/env python3
import os
from collections import defaultdict


folder_to_faction = {
	"aquana": "aq",
	"dwarves": "dw",
	"elves-dark": "de",
	"elyser": "ey",
	"gnomes": "fd",
	"human-chevalier": "ce",
	"human-dardo": "dr",
	"human-forest": "fh",
	"human-luz": "lz",
	"human-mountain": "mh",
	"human-regis": "rg",
	"marashy": "ma",
	"trarashy": "tr",
	"undead": "ne",
	"vixens": "vx"
}

ships_to_faction = {
	"C": "ce",
	"D": "dr",
	"E": "de",
	"Ra": "ma",
	"Re": "rg"
}


def get_unit_type_mapping(source="."):
	unit_type_mapping = {}
	for dname, dirs, files in os.walk(source):
		if "units" not in dname:
			continue
		if "Ageless_Era" in dname or "images" in dname:
			continue
		
		for fname in files:
			fpath = os.path.join(dname, fname)
			faction_folder = dname.split("\\")[-1].split("/")[-1]
			
			with open(fpath,encoding="utf8") as f:
				unit_type = False
				for line in f:
					if "#define VR_" in line and "MOVEMENT M_TYPE GRAPHIC" in line:
						continue
					if unit_type:
						if "id" in line:
							old_type = line.split("=")[1].strip()
							
							if faction_folder == "ships":
								faction = ships_to_faction[fname.split("_")[0]]
							else:
								faction = folder_to_faction[faction_folder]
							
							new_type = "AE_rhy_"+faction+"_" + old_type.split(" ", 1)[-1].replace(" ", "_")
							unit_type_mapping[old_type] = new_type
							break
						else:
							raise Exception("Expected id after [unit_type]. " + line + dname + fname)
					if "[unit_type]" in line:
						unit_type=True
	return unit_type_mapping
	
if __name__ == "__main__":
	print(get_unit_type_mapping(source="../../Rashy_Era/units"))
