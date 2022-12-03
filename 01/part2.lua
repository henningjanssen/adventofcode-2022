function fileInventoryIterator (filename)
    local file = assert(io.open(filename, 'r'))

    return function ()
            local calories = 0
            while true do
                line = file:read('*line')
                if line == nil then break end
                if line == '' then
                    return calories
                end
                calories = calories + tonumber(line)
            end
            file:close()
            return nil
        end
end

function fileInventoryIteratorFactory (filename)
    return function ()
        return fileInventoryIterator(filename)
    end
end

function findNLargestInventories (inventoryIterator, n)
    local inventories = {}
    local idx = 0
    for calories in inventoryIterator() do
        inventories[idx] = calories
        idx = idx + 1
    end

    table.sort(inventories)

    local sum = 0
    for i = 0, n-1 do
        sum = sum + inventories[#inventories - i]
    end
    return sum
end

function main()
    local filename = assert(arg[1])
    local n = tonumber(assert(arg[2]))
    local itInventory = fileInventoryIteratorFactory(filename)
    local calorySum = findNLargestInventories(itInventory, n)
    print('N: ', n)
    print('Calories: ', calorySum)
end

main()
