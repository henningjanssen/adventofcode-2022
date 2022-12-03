function fileMatchIterator (filename)
    local file = assert(io.open(filename, 'r'))

    return function ()
            while true do
                line = file:read('*line')
                if line == nil then break end
                return string.sub(line, 1, 1), string.sub(line, 3, 3)
            end
            file:close()
            return nil
        end
end

function fileMatchIteratorFactory (filename)
    return function ()
        return fileMatchIterator(filename)
    end
end


function getShapeForResult(opponentShape, result)
    if result == "Y" then
        return opponentShape
    -- much cooler would be indexof+1 mod #shapes with shapes = {"X", "Y", "Z"}
    elseif result == "Z" then
        local wins = {
            ["A"] = "B",
            ["B"] = "C",
            ["C"] = "A",
        }
        return wins[opponentShape]
    else
        local loses = {
            ["A"] = "C",
            ["B"] = "A",
            ["C"] = "B",
        }
        return loses[opponentShape]
    end
end

function getShapeScore(shape)
    if shape == "A" then return 1
    elseif shape == "B" then return 2
    end
    return 3
end

function getMatchScore(result)
    local scores = {
        ["X"] = 0,
        ["Y"] = 3,
        ["Z"] = 6,
    }
    return scores[result]
end

function getScore(ownShape, result)
    return getShapeScore(ownShape) + getMatchScore(result)
end

function getCompetitionScore(matchIterator)
    local totalScore = 0
    for opponentShape, result in matchIterator() do
        ownShape = getShapeForResult(opponentShape, result)
        totalScore = totalScore + getScore(ownShape, result)
    end
    return totalScore
end

function main()
    local inputFilename = assert(arg[1])
    local itMatches = fileMatchIteratorFactory(inputFilename)
    local score = getCompetitionScore(itMatches)
    print('Score:', score)
end

main()
