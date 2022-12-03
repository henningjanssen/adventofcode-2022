max_elve = 0
max_cals = 0
elve = 0
cals = 0
for line in io.lines("input.txt") do
    if line == "" then
        cals = 0
        elve = elve + 1
    else
        cals = cals + tonumber(line)
        if cals > max_cals then
            max_cals = cals
            max_elve = elve
        end
    end
end
io.write("elve ", max_elve, " carries ", max_cals, "\n")
