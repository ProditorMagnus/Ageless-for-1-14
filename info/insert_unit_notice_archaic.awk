#!/usr/bin/awk -f

# inserts unit notice
# adds prefix to »id« key of each unit_type
# adds prefix to »id« key of each race
# does not:
# - add prefix to advances_to
#   Problem: komma
# - add prefix to »race« key in unit_types:
#   Problem: also mainline races are used
# - handle base_unit cases, done by bash

BEGIN {
   in_unit_type = 0;
   in_subtag = 0;
   in_race = 0;
}

#### rules for matching
# used to keep track

/\[unit_type\]/ {
    in_unit_type++;
}

/\[\/unit_type\]/ {
    in_unit_type--;
}

/\[race\]/ {
    in_race++;
}

/\[\/race\]/ {
    in_race--;
}

/\[(attack|abilities|advancement)\]/ {
    in_subtag++;
}

/\[\/(attack|abilities|advancement)\]/ {
    in_subtag--;
}

#### rules for matching
# used to manipulate

/[[:blank:]]description.?=/ {
    if (in_unit_type && (!in_subtag)) {
        sub("description=" , "description={AE_ARC_UNIT_NOTICE} + ");
    }
}

/[[:blank:]]id.?=/ {
    if (in_unit_type && (!in_subtag)) {
        sub("id=" , "id=AE_arc_");
    }
}

/[[:blank:]]id.?=/ {
    if (in_race) {
        sub("id=" , "id=AE_arc_");
    }
}

/[[:blank:]]id.?=/ {
    if (in_race) {
        sub("description=" , "description={AE_ARC_RACE_NOTICE} + ");
    }
}

#### action

{ print }
