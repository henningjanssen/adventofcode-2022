%export part1

getlines :: [char] -> [[char]]
getlines filename
    = (lines . read) filename

getboundsstrs :: [char] -> [[char]]
getboundsstrs line
    = flatten [splitstr i '-' | i <- (splitstr line ',')]

flatten :: [[*]] -> [*]
flatten [] = []
flatten (a:x)
    = a ++ (flatten x)

splitstr :: [char] -> char -> [[char]]
splitstr (a:x) delim
    = []:splitstr x delim, if a = delim
    = (a:x1):xrest, otherwise
        where
        (x1:xrest)  = splitstr x delim, if x~=[]
                    = []:[], otherwise

getbounds :: [char] -> [num]
getbounds line
    = map numval (getboundsstrs line)

inbounds :: [num] -> bool
inbounds (a:b:c:d:x)
    = or [and [a <= c, b >= d], and [a >= c, b <= d]]

overlaps :: [num] -> bool
overlaps (a:b:c:d:x)
    = or [and [a <= c, b >= c], and [a <= d, b >= d], and [c <= a, d >= a], and [c <= b, c >= b]]

booltonum :: bool -> num
booltonum True = 1
booltonum False = 0

part1 :: [char] -> sys_message
part1 infile = (Stdout . show . sum) [(booltonum . inbounds . getbounds) line | line <- (getlines infile)]

part2 :: [char] -> sys_message
part2 infile = (Stdout . show . sum) [(booltonum . overlaps . getbounds) line | line <- (getlines infile)]
