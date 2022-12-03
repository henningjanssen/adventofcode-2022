function fileInventoryIterator (filename)
    local file = assert(io.open(filename, 'r'))
    local idx = 0

    return function ()
            local calories = 0
            while true do
                line = file:read('*line')
                if line == nil then break end
                if line == '' or line == nil then
                    idx = idx + 1
                    return idx - 1, calories
                end
                calories = calories + tonumber(line)
            end
            file:close()
            return nil, nil
        end
end

function fileInventoryIteratorFactory (filename)
    return function ()
        return fileInventoryIterator(filename)
    end
end

function findLargestInventory (inventoryIterator)
    local maxCalories = 0
    local maxElve = 0
    for elve, calories in inventoryIterator() do
        if calories > maxCalories then
            maxCalories = calories
            maxElve = elve
        end
    end
    return maxElve, maxCalories
end

function main()
    local filename = assert(arg[1])
    local itInventory = fileInventoryIteratorFactory(filename)
    local elve, calories = findLargestInventory(itInventory)
    print('Elve: ', elve)
    print('Calories: ', calories)
end

main()
