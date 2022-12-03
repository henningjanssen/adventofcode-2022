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

function translateOwnShape(shape)
    local trans = {
        ["X"] = "A",
        ["Y"] = "B",
        ["Z"] = "C",
    }
    return trans[shape]
end

function getShapeScore(shape)
    if shape == "A" then return 1
    elseif shape == "B" then return 2
    end
    return 3
end

function getMatchScore(opponentShape, ownShape)
    if opponentShape == ownShape then return 3 end
    local wins = {
        ["A"] = "B",
        ["B"] = "C",
        ["C"] = "A",
    }
    if ownShape == wins[opponentShape] then return 6 end
    return 0
end

function getScore(opponentShape, ownShape)
    return getShapeScore(ownShape) + getMatchScore(opponentShape, ownShape)
end

function getCompetitionScore(matchIterator)
    local totalScore = 0
    for opponentShape, ownShape in matchIterator() do
        ownShape = translateOwnShape(ownShape)
        totalScore = totalScore + getScore(opponentShape, ownShape)
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
