#!/usr/bin/env python3
import os
from collections import defaultdict


folder_to_faction = {
	"frakcja1": "pirates",
	"frakcja2": "natives",
	"frakcja3": "bloodelf",
	"frakcja4": "amazon",
	"frakcja5": "altaris"
}


def get_unit_type_mapping(source="."):
	unit_type_mapping = {}
	unit_file_mapping = {}
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
				unit_type_name = None
				old_type = None
				for line in f:
					if unit_type:
						if "id=" in line:
							old_type = line.split("=")[1].strip()
						elif "name=" in line:
							unit_type_name = line.split("=")[1].replace('"',"").replace("_","").strip()
						else:
							raise Exception("Expected id after [unit_type]. " + line + dname + "/" + fname)
						if old_type is not None and unit_type_name is not None:
							faction = folder_to_faction[faction_folder]
							
							new_type = "AE_FL_"+faction+"_" + unit_type_name.replace(" ", "_")
							unit_type_mapping[old_type] = new_type
							unit_file_mapping[fname] = unit_type_name.replace(" ", "_")+".cfg"
							break
						
							
					if "[unit_type]" in line:
						unit_type=True
	return [unit_type_mapping, unit_file_mapping]
	
if __name__ == "__main__":
	print(get_unit_type_mapping(source="../units/FL_units"))
