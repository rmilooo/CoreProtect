function OnPlayerPlacedBlock(Player, BlockX, BlockY, BlockZ, BlockType, BlockMeta)
    local PlayerName = Player:GetName()
    if not BlockLog[PlayerName] then
        BlockLog[PlayerName] = {}
    end

    table.insert(BlockLog[PlayerName], {
        Action = "Place",
        X = BlockX, Y = BlockY, Z = BlockZ,
        BlockType = BlockType, BlockMeta = BlockMeta,
        Timestamp = os.time()
    })
end

function OnPlayerBrokenBlock(Player, BlockX, BlockY, BlockZ, BlockType, BlockMeta)
    local PlayerName = Player:GetName()
    if not BlockLog[PlayerName] then
        BlockLog[PlayerName] = {}
    end

    table.insert(BlockLog[PlayerName], {
        Action = "Break",
        X = BlockX, Y = BlockY, Z = BlockZ,
        BlockType = BlockType, BlockMeta = BlockMeta,
        Timestamp = os.time()
    })
end
