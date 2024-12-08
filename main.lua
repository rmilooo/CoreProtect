function Initialize(Plugin)
    Plugin:SetName("CoreProtectLikePlugin")
    Plugin:SetVersion(1)

    cPluginManager.BindCommand("/rollback", "coreprotect.rollback", Rollback, " ~ Rollback block changes")
    cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_PLACED_BLOCK, OnPlayerPlacedBlock)
    cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_BROKEN_BLOCK, OnPlayerBrokenBlock)

    LOG("Initialized " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())
    return true
end
