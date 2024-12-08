function Rollback(Split, Player)
    if (#Split ~= 3) then
        Player:SendMessage("Usage: /rollback [playername] [time in minutes]")
        return true
    end

    local TargetName = Split[2]
    local RollbackTime = tonumber(Split[3]) or 0
    local CurrentTime = os.time()
    local RollbackThreshold = CurrentTime - (RollbackTime * 60)
    local World = Player:GetWorld()

    if not BlockLog[TargetName] then
        Player:SendMessageFailure("No data found for " .. TargetName)
        return true
    end

    local RollbackCount = 0
    local TotalChanges = 0  -- To track total changes during rollback
    local RestoredChanges = 0  -- To track how many changes were restored

    -- Iterate through the logged blocks in reverse order (recent changes first)
    for i = #BlockLog[TargetName], 1, -1 do
        local Entry = BlockLog[TargetName][i]

        -- Debug message to check block data
        LOG("Processing: " .. TargetName .. " Action: " .. Entry.Action .. " Timestamp: " .. Entry.Timestamp)

        -- Check if the timestamp is within the rollback threshold
        if Entry.Timestamp >= RollbackThreshold then
            -- Create the vector position using cVector3i
            local Position = Vector3i(Entry.X, Entry.Y, Entry.Z)

            -- Perform the rollback action based on the type of block change
            if Entry.Action == "Place" then
                World:SetBlock(Position, 0, 0)  -- Set to air
                LOG("Rolled back block place: " .. Entry.BlockType .. " | " .. Entry.BlockMeta)
            elseif Entry.Action == "Break" then
                World:SetBlock(Position, Entry.BlockType, Entry.BlockMeta)  -- Restore block
                LOG("Rolled back block break: " .. Entry.BlockType .. " | " .. Entry.BlockMeta)
            end

            -- Remove the entry after rollback
            table.remove(BlockLog[TargetName], i)
            RollbackCount = RollbackCount + 1
            RestoredChanges = RestoredChanges + 1
        else
            TotalChanges = TotalChanges + 1
        end
    end

    -- Send appropriate success/failure message
    if RestoredChanges > 0 then
        Player:SendMessageSuccess("Rolled back " .. RestoredChanges .. " changes for " .. TargetName .. ".")
    else
        Player:SendMessageFailure("No changes found for rollback in the last " .. RollbackTime .. " minutes.")
    end

    if TotalChanges > 0 then
        -- Debug: Provide details on blocks that were not within the time frame
        LOG("Total blocks processed: " .. TotalChanges .. " | Skipped " .. (TotalChanges - RollbackCount) .. " changes.")
    end

    return true
end
