Object subclass: Node [
    | name children size type parent |
    new [
        | r |
        <category: 'instance creation'>
        r := super new.
        r init.
        ^r
    ]
    init [
        <category: 'initialization'>
        children := Dictionary new.
        size := 0.
        type := 'u'.
        parent := nil.
        name := ''.
        ^self
    ]
    traverseTo: dir [
        ^children at: dir.
    ]
    addChild: child [
        children notNil ifFalse: [children := Dictionary new.].
        child parent: self.
        children at: (child name) put: child.
        self propagateSize: (child size).
    ]
    propagateSize: s [
        size := size + s.
        parent notNil ifTrue: [parent propagateSize: s].
    ]
    name [
        ^name.
    ]
    name: aName [
        name := aName.
    ]
    size [
        ^size.
    ]
    size: aSize [
        size := aSize.
    ]
    type [
        ^type.
    ]
    type: aType [
        type := aType.
    ]
    parent [
        ^parent
    ]
    parent: aParent [
        parent := aParent.
    ]
    part1 [
        | sum thresh |
        thresh := 100000.
        sum := 0.
        (size <= thresh) ifTrue: [sum := size].
        children do: [:child | 
            ((child type) = 'd')
                ifTrue: [sum := sum + (child part1).].
        ].
        ^sum.
    ]
    part2: thresh [
        | minmax |
        (size >= thresh)
            ifTrue: [minmax := size.]
            ifFalse: [minmax := 0.].
        children do: [:child |
            ((child type) = 'd')
                ifTrue: [
                    | childmax |
                    childmax := child part2: thresh.
                    ((childmax >= thresh) & (childmax < minmax)) ifTrue: [minmax := childmax.].
                ].
        ].
        ^minmax.
    ]
]

root := Node new.
root name: '/'.
root size: 0.
root type: 'd'.
currentNode := root.

currentMode := 'none'.
file := FileStream open: 'input.txt' mode: FileStream read.
file linesDo: [:l |
    parts := l substrings: ' '.
    ((parts first) = '$') ifTrue: [
        | op |
        currentMode := parts at: 2.
        op := parts at: 2.
        (op = 'cd')
            ifTrue: [
                | target |
                target := parts at: 3.
                (target = '/')
                    ifTrue: [currentNode := root]
                    ifFalse: [
                        (target = '..')
                            ifTrue: [currentNode := currentNode parent]
                            ifFalse: [currentNode := (currentNode traverseTo: (parts at: 3))].
                    ].
            ]
            ifFalse: [].
    ] ifFalse: [
        | n |
        n := Node new.
        n name: parts last.
        ((parts first) = 'dir') ifTrue: [
            n size: 0.
            n type: 'd'.
        ] ifFalse: [
            n size: parts first asNumber.
            n type: 'f'.
        ].
        currentNode addChild: n.
    ].
].

part1 := root part1.
Transcript show: 'part1: ', part1 asString; nl.

part2total := 70000000.
part2required := 30000000.
part2tobefreed := part2required + (root size) - part2total.
part2 := root part2: part2tobefreed.
Transcript show: 'part2: ', part2 asString; nl.
