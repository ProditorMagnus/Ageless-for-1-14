max_line_length=200
-- show the warning/error codes as well
codes=true
-- skip showing files with no issues
quiet=1
-- checks related to undefined variable usage
-- there can be warnings because luacheck is unaware of Wesnoth's
-- lua environment and has no way to check which have been loaded
globals={"wesnoth","wml","gui","filesystem","unit_test","stringx","mathx","ai"}
-- allow_defined=true
-- allow_defined_top=true
-- skip showing unused variables
-- unused=false
-- (W542) empty if branch
ignore={"542"}