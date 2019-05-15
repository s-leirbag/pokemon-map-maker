function GenerateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] =
                love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth,
                tileheight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end

function GenerateOutsideQuads()
    local quads = GenerateQuads(gTextures['outside'], 16, 16)

    tilesheet = {}
    tilesheet['grass'], tilesheet['half-tall-grass'], tilesheet['tall-grass'], tilesheet['extra-tall-grass'] = GenerateGrassQuads(quads)
    tilesheet['path'] = GeneratePathQuads(quads)

    return tilesheet
end

function GenerateGrassQuads(quads)
    local grass = {}

    grass[1] = {}
    for i = 1, 5 do
        table.insert(grass[1], quads[i])
    end

    local halfTallGrass = {}
    halfTallGrass[1] = {}
    table.insert(halfTallGrass[1], quads[6])

    local tallGrass = {}
    tallGrass[1] = {}
    table.insert(tallGrass[1], quads[7])

    local extraTallGrass = {}
    extraTallGrass[1] = {}
    table.insert(extraTallGrass[1], quads[8])
    table.insert(extraTallGrass[1], quads[16])

    return grass, halfTallGrass, tallGrass, extraTallGrass
end

function GeneratePathQuads(quads)
    local tilesheet = {}
    local offset = 40

    for color = 1, 5 do
        tilesheet[color] = {}

        for i = 1, 56 do
            table.insert(tilesheet[color], quads[i + offset])
        end

        offset = offset + 56
    end

    return tilesheet
end

function GeneratePlayerQuads()
    local quads = {
        ['boy'] = {
            ['boy-run'] = GenerateQuads(gTextures['boy-run'], 16, 24),
            ['boy-bike'] = GenerateQuads(gTextures['boy-bike'], 24, 24),
            ['boy-surf'] = GenerateQuads(gTextures['boy-surf'], 16, 24),
            ['boy-fish'] = GenerateQuads(gTextures['boy-fish'], 48, 40)
        },
        ['girl'] = {
            ['girl-run'] = GenerateQuads(gTextures['girl-run'], 16, 24),
            ['girl-bike'] = GenerateQuads(gTextures['girl-bike'], 24, 24),
            ['girl-surf'] = GenerateQuads(gTextures['girl-surf'], 16, 24),
            ['girl-fish'] = GenerateQuads(gTextures['girl-fish'], 48, 40)
        }
    }
    
    return quads
end

function GenerateBagQuads()
    local quads = {
        ['background'] = GenerateQuads(gTextures['bag-background'], 256, 192),
        ['boy'] = {},
        ['girl'] = {}
    }

    local bagQuads = GenerateQuads(gTextures['bag'], 64, 64)
    for i = 1, 8 do
        table.insert(quads['boy'], bagQuads[i])
    end

    for i = 9, 16 do
        table.insert(quads['girl'], bagQuads[i])
    end

    return quads
end