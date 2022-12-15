include std/filesys.e
include std/io.e
include std/search.e

sequence visibilityMap = {}
sequence topmax = {}
sequence bottomVisibilityLine = {}
sequence bottomMax = {}
integer count = 0

sequence zero = "0"
atom digitOffset = zero[1]

-- part1
function processLine(sequence aLine, integer line_no, object data)
    aLine = aLine - digitOffset
    if line_no = 1 then
        topmax = aLine
        bottomMax = aLine
        bottomVisibilityLine = repeat(repeat(-1, 10), length(aLine))
        for i = 1 to length(aLine) do
            bottomVisibilityLine[i][aLine[i]+1] = 1
        end for
        count = count + length(aLine)
        return 0
    end if
    
    integer leftmax = aLine[1]
    integer rightmax = aLine[1]
    sequence rightseen = repeat({0, -1}, 10)
    rightseen[aLine[1]+1] = {1, 1}
    sequence bottomPotentials = {}
    count = count + 2
    for i = 2 to length(aLine) do
        atom counted = 0
        if i = length(aLine) then counted = 1 end if
        -- top
        if aLine[i] > topmax[i] then
            topmax[i] = aLine[i]
            if counted = 0 then
                count = count + 1
                counted = 1
            end if
        end if

        -- left
        if aLine[i] > leftmax then
            leftmax = aLine[i]
            if counted = 0 then
                count = count + 1
                counted = 1
            end if
        end if

        -- right
        if aLine[i] >= rightmax then
            for j = aLine[i] to rightmax+1 by -1 do
                rightseen[j] = {0, -1}
            end for
        end if
        rightseen[aLine[i]+1] = {i, counted}
        rightmax = aLine[i]

        -- bottom
        if aLine[i] >= bottomMax[i] then
            for j = aLine[i] to bottomMax[i]+1 by -1 do
                bottomVisibilityLine[i][j] = -1
            end for
        end if
        if counted = 0 then
            bottomPotentials = append(bottomPotentials, i)
        end if
        bottomVisibilityLine[i][aLine[i]+1] = counted
        bottomMax[i] = aLine[i]
    end for

    -- coming from the right, count the leftovers and leave the rest to the bottom
    for i = 1 to length(rightseen) do
        if rightseen[i][2] = 0 then
            count = count + 1
            integer idx = rightseen[i][1]
            if binary_search(idx, bottomPotentials) > 0 then
                bottomVisibilityLine[idx][aLine[idx]+1] = 1
            end if
        end if
    end for
    return 0
end function

io:process_lines("input.txt", routine_id("processLine"))
for i = 1 to length(bottomVisibilityLine) do
    for j = 1 to length(bottomVisibilityLine[i]) do
        if bottomVisibilityLine[i][j] = 0 then
            count = count + 1
        end if
    end for
end for

printf(STDOUT, "part1: %d\n", {count})
