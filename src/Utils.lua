function importAdventurerAssets()
    local assets = {}

    local files = love.filesystem.getDirectoryItems('assets/Adventurer/')
    local prefix = 'adventurer-'
    local ending = '-00.png'

    for k, file in pairs(files) do
        local state = string.sub(file, #prefix + 1, #file - #ending)
        local full_file_path = 'assets/Adventurer/' .. file
        print(state)
        if assets[state] == nil then
            assets[state] = {}
        end
        table.insert(assets[state], love.graphics.newImage(full_file_path))
    end

    return assets
end