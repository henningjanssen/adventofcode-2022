import std/hashes
import std/sets
import strutils

type
    Position = tuple
        x: int
        y: int
    Status = tuple
        body: seq[Position]
        tailHistory: HashSet[Position]

proc hash(x: Position): Hash =
    hash($(x.x) & "#" & $(x.y))

proc processMovement(status: var Status, line: string) =
    let parts = line.split(" ")
    let direction: string = parts[0]
    let amount: int = parseInt(parts[1])

    var
        moveX: int = case direction
            of "L": -1
            of "R": 1
            else: 0
        moveY: int = case direction
            of "U": 1
            of "D": -1
            else: 0
            
    for i in 0..amount-1:
        status.body[0].x += moveX
        status.body[0].y += moveY
        for i in 1..len(status.body)-1:
            let diffX = status.body[i-1].x - status.body[i].x
            let diffY = status.body[i-1].y - status.body[i].y
            if (diffX*diffX + diffY*diffY) > 2:
                status.body[i].x += (if abs(diffX) > 0: (int) diffX/abs(diffX) else: 0)
                status.body[i].y += (if abs(diffY) > 0: (int) diffY/abs(diffY) else: 0)
        status.tailHistory.incl(status.body[len(status.body)-1])

proc main(filename: string) = 
    let file = readFile(filename)
    let lines = file.splitLines()

    var statusPart1: Status = (body: @[(x: 0, y: 0)], tailHistory: initHashSet[Position]())
    statusPart1.tailHistory.incl(Position (x: 0, y: 0))
    statusPart1.body.add((x: 0, y: 0))

    var statusPart2: Status = (body: @[(x: 0, y: 0)], tailHistory: initHashSet[Position]())
    statusPart2.tailHistory.incl(Position (x: 0, y: 0))
    for i in 1..9:
        statusPart2.body.add((x: 0, y: 0))

    for line in lines:
        if line.len == 0:
            continue
        statusPart1.processMovement(line)
        statusPart2.processMovement(line)
    echo "part1: " & $len(statusPart1.tailHistory)
    echo "part2: " & $len(statusPart2.tailHistory)

main("input.txt")
