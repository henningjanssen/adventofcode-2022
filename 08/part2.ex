include std/filesys.e
include std/io.e

sequence scenicScores = {}
sequence topView = {}
sequence bottomView = {}
integer maxScore = 0

sequence zero = "0"
atom digitOffset = zero[1]

function processLine(sequence aLine, integer line_no, object data)
    aLine = aLine - digitOffset

    if line_no = 1 then
        topView = repeat(repeat(0, 10), length(aLine))
        bottomView = repeat(repeat(0, 10), length(aLine))
        for i = 1 to length(aLine) do
            topView[i][aLine[i]+1] = 1
            bottomView[i][aLine[i]+1] = 1
        end for
        scenicScores = append(scenicScores, repeat(0, length(aLine)))
        return 0
    end if

    sequence scenicLine = {0}

    sequence leftView = repeat(0, 10)
    leftView[aLine[1]+1] = 1

    sequence rightView = repeat(0, 10)
    rightView[aLine[1]+1] = 1

    for i = 2 to length(aLine) do
        integer height = aLine[i]
        integer idx = 0
        integer leftDist = i - 1
        integer topDist = line_no - 1
        for j = height+1 to 10 do
            if i - leftView[j] < leftDist then
                leftDist = i - leftView[j]
            end if
            if line_no - topView[i][j] < topDist then
                topDist = line_no - topView[i][j]
            end if
        end for

        for j = 1 to height+1 do
            if rightView[j] > 0 then
                scenicLine[rightView[j]] = scenicLine[rightView[j]] * (i - rightView[j])
                rightView[j] = 0
            end if
            if bottomView[i][j] > 0 then
                integer newScore = scenicScores[bottomView[i][j]][i] * (line_no - bottomView[i][j])
                scenicScores[bottomView[i][j]][i] = newScore
                bottomView[i][j] = 0
                if newScore > maxScore then
                    maxScore = newScore
                end if
            end if
        end for

        leftView[height+1] = i
        topView[i][height+1] = line_no
        rightView[height+1] = i
        bottomView[i][height+1] = line_no

        integer score = leftDist * topDist
        scenicLine = append(scenicLine, score)
    end for

    for i = 1 to length(rightView) do
        if rightView[i] > 0 then
            scenicLine[rightView[i]] = scenicLine[rightView[i]] * (length(aLine) - rightView[i])
        end if
    end for
    scenicScores = append(scenicScores, scenicLine)

    return 0
end function

io:process_lines("input.txt", routine_id("processLine"))

for i = 1 to length(bottomView) do
    for j = 1 to length(bottomView[i]) do
        if bottomView[i][j] > 0 then
            integer newScore = scenicScores[bottomView[i][j]][i] * (length(scenicScores) - bottomView[i][j])
            scenicScores[bottomView[i][j]][i] = newScore
            if newScore > maxScore then
                maxScore = newScore
            end if
        end if
    end for
end for

printf(STDOUT, "part2: %d\n", {maxScore})
