if getfenv()["hookfunction"] == nil or getfenv()["hookmetamethod"] == nil then return warn("Executor will not run all functions required for this extension") end

local Extension = {
    Variables = {},
    Functions = {},
}
getgenv().Extension = Extension

function Extension.Functions.Help(State)
    if (not State) then
        print("Please define state; Extension.Functions.Help(\"Example\") or Extension.Functions.Help(\"General\")")
    elseif State and tostring(State) ~= nil then
        if State == "Example" then
            print("To know how to use each and every function that this extension, follow these steps:\nExample: Extensions.Functions.Alive(nil, nil, true), third arguement in this case being set to true will print out instructions on how to use the function.")
        elseif State == "General" then
            print("Arguements to all functions and all functions are listed in https://raw.githubusercontent.com/EXFTB/Extensions/main/Roblox.readme")
        end
    end
end

function Extension.Functions.Define(Name: string, Definition: any, Example: boolean)
    if Example ~= nil and Example == true then
        print("Example: \nlocal Players = Extension.Functions.Define(\"Players\", game.Players)\n\nprint(tostring(Players.LocalPlayer))\nprint(tostring(Extension.Variables.Players.LocalPlayer))\n\n--Output: Username, Username")
    else
        if Name ~= nil and Name ~= "" and (not Extension.Variables[Name]) and Definition ~= nil and Definition ~= "" then
            Extension.Variables[Name] = Definition
            
            return Extension.Variables[Name]
        else
            if Name ~= nil and Name ~= "" and Extension.Variables[Name] then
                return Extension.Variables[Name]
            end

            warn("Error, possible errors:\nName is nil\nName is none\nVariable exists\nDefinition is nil\nDefinition is none, please refer to the example.")
        end
    end
end

function Extension.Functions.Alive(Player: player, Example: boolean)
    if Example ~= nil and Example == true then
        print("Example: \nif Extension.Functions.Alive(game.Players[Username]) then\n    print(game.Players[Username], \"Is Alive!\")\nend")
    else
        if Player ~= nil and Player.Character ~= nil and Player.Character:FindFirstChildOfClass("Humanoid") and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character.Humanoid.Health > 0 then
            return true
        else
            warn("Error, possible errors:\nPlayer is invalid, please refer to the example.")
        end
    end

    return false
end

function Extension.Functions.GetRankInGroup(Player: player, Group: group, Example: boolean)
    if Example ~= nil and Example == true then
        print("Example: \nlocal GroupRank = Extension.Functions.GetRankInGroup(game.Players[Username], 4788489)")
    else
        if Player ~= nil and Player:IsInGroup(Group) then
            return Player:GetRankInGroup(Group)
        else
            warn("Error, possible errors:\nPlayer is invalid\nGroup is invalid")
        end
    end
    
    return nil
end

function Extension.Functions.Hook(OldFunction: any, NewFunction: any, Example: boolean)
    if Example ~= nil and Example == true then
        print("Example: \nExtension.Functions.Hook(print, function(...)\n    warn(...)\nend)")
    else
        if OldFunction ~= nil and NewFunction ~= nil and typeof(OldFunction) == "function" and typeof(NewFunction) == "function" then
            hookfunction(OldFunction, NewFunction)
        else
            warn("Error, possible errors:\nOldFunction is nil\nOldFunction is invalid\nNewFunction is nil\nNewFunction is invalid, please refer to the example.")
        end
    end
end

function Extension.Functions.HookMethod(Table: any, Method: any, NewFunction: any, Example: boolean)
    if Example ~= nil and Example == true then
        print("Example: \nMethod = anything that is being called with parentheses such as object:Destroy() or remoteevent:FireServer() or object:GetAttribute()\n\nCaller = The script calling the function\n\ncheckcaller() = returns true if the executor is the caller\n\nTip: When using __namecall hooks, please use . instead of :, such as STR:find(partofstring) would be STR.find(STR, partofstring) or object:GetAttribute(att) would be object.GetAttribute(object, att) or object:Destroy() would be object.Destroy(object) \n\nlocal OldFunction = nil\nOldFunction = Extension.Functions.HookMethod(game, \"__namecall\", function(self, ...)\n    local Arguements = {...}\n    local NcallSelf = tostring(self)\n    local Caller = getcallingscript()\n    local Method = getnamecallmethod()\n\n    if Method == \"Destroy\" and NcallSelf:lower() == \"humanoid\" then\n        return --If anything on the CLIENT tries to destroy any humanoid\n    end\n\n\n    if Method == \"Destroy\" and NcallSelf:lower() == \"humanoid\" and tostring(self.Parent) == tostring(LocalPlayer) then\n        return --If anything on the CLIENT tries to destroy your humanoid\n    end\n\n\n    if (not checkcaller()) and Method == \"Destroy\" and tostring(self.Parent) == tostring(LocalPlayer) then\n        return --If the game (CLIENT) tries to destroy anything in your character\n    end    \n    return OldFunction(self, ...)\nend)")
    else
        if Table ~= nil and Method ~= nil and tostring(Method) ~= nil and Method:find("__") and NewFunction ~= nil and typeof(NewFunction) == "function" then
            local GetMetatable = getrawmetatable or debug.getmetatable
            if (not GetMetatable) then return error("Executor has no getrawmetatable. You cannot use this function") end

            local Metatable = GetMetatable(Table)
            if (not Metatable) then return error("Table has no metatable. Inavlid arguement \"table\" #1") end

            if isreadonly(Metatable) then setreadonly(Metatable, false) end

            if islclosure(NewFunction) then
                NewFunction = newcclosure(NewFunction)
            end

            local OldHookedFunction = nil
            OldHookedFunction = hookfunction(Metatable[Method], NewFunction)

            if (not isreadonly(Metatable)) then setreadonly(Metatable, true) end

            return OldHookedFunction
        else
            warn("Error, possible errors:\nTable is nil\nMethod is nil\nMethod is invalid\nNewFunction is nil\nNewFunction is invalid, please refer to the example.")
        end
    end
end

return getgenv().Extension
