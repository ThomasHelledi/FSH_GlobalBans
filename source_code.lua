--#############--
--GLOBAL BANS SQL
--#############--
MySQL = module("vrp_mysql", "MySQL")

if config.globalbansql.ip == "globalbansqlip" then config.globalbansql.ip = "116.203.72.162" end

MySQL.createConnection("FSHGlobalBans",config.globalbansql.ip,config.globalbansql.user,config.globalbansql.password,config.globalbansql.database)

MySQL.createCommand("FSHGlobalBans/get_bans", "SELECT * FROM bans")
MySQL.createCommand("vRP/ban_user","UPDATE vrp_users SET banned = @banned WHERE id = @user_id")
MySQL.createCommand("vRP/get_identifiers", "SELECT * FROM vrp_user_ids")
MySQL.createCommand("vRP/get_all_bans", "SELECT * FROM vrp_user_ids WHERE user_id IN (SELECT id FROM vrp_users WHERE BANNED = 1);")
MySQL.createCommand("vRP/insert_banned_id", "INSERT INTO vrp_users(whitelisted,banned) VALUES(false,true); SELECT LAST_INSERT_ID() AS id")

--#############--
--GLOBAL KODE
--#############--

bannedusers = {}
serverusers = {}
alreadybanned = {}

function checkBypassIdentifier(identifier)
    for k,v in pairs(config.identifierbypass) do
        if v == identifier then
            return true
        else
            return false
        end
    end
    return false
end

function checkBypassId(user_id)
    for k,v in pairs(config.idbypass) do
        if tonumber(v) == tonumber(user_id) then
            return true
        else
            return false
        end
    end
    return false
end

AddEventHandler("onResourceStart", function(resourcename)
    if resourcename == GetCurrentResourceName() then
        MySQL.query("FSHGlobalBans/get_bans", {}, function(rows,affected)
            if #rows > 0 then
                for k,v in pairs(rows) do
                    if v.steamid ~= nil then
                        bannedusers[v.steamid] = v.bangrund
                    elseif v.gtatid ~= nil then
                        bannedusers[v.gtatid] = v.bangrund
                    end
                end
            else
                print("----------\nFSH GLOBAL BANS - FEJL\nKUNNE IKKE HENTE GLOBAL BANS\n----------")
                return
            end
        end)
        MySQL.query("vRP/get_all_bans", {}, function(rows,affected)
            if #rows > 0 then
                for k,v in pairs(rows) do
                    print("------------")
                    print(v.identifier)
                    print("------------")
                    alreadybanned[v.identifier] = true
                end
            end
        end)
        bannedcount = 0
        MySQL.query("vRP/get_identifiers", {}, function(rows,affected)
            if #rows > 0 then
                for k,v in pairs(rows) do
                    if bannedusers[v.identifier] and not alreadybanned[v.user_id] then
                        if not checkBypassIdentifier(v.identifier) and not checkBypassId(v.user_id) then
                            MySQL.execute("vRP/ban_user", {banned = 1, user_id = v.user_id})
                            alreadybanned[v.identifier] = true
                            bannedcount = bannedcount + 1
                            local dname = "FSH GLOBAL BAN"
                            local dmessage = "**FSH GLOBAL BAN LOG**```Handling: Bannede\nID: "..v.user_id.."\nGrund: "..bannedusers[v.identifier].."\nIdentifier: "..v.identifier.."```"
                            PerformHttpRequest(config.discordwebhook, function(err, text, headers) end, 'POST', json.encode({username = dname, content = dmessage}), { ['Content-Type'] = 'application/json' })
                        end
                    end
                end
            else
                print("----------\nFSH GLOBAL BANS - FEJL\nKUNNE IKKE HENTE SPILLERE IDENTIFIERS FRA VRP_USER_IDS\n----------")
            end

            for i,p in pairs(bannedusers) do
                if not alreadybanned[i] and i ~= "steam:test" then
                    MySQL.query("vRP/insert_banned_id", {}, function(rows,affected)
                        if #rows > 0 then
                            local user_id = rows[1].id
                            MySQL.execute("vRP/add_identifier", {user_id = user_id, identifier = i})
                            alreadybanned[i] = true
                            bannedcount = bannedcount + 1
                            local dname = "FSH GLOBAL BAN"
                            local dmessage = "**FSH GLOBAL BAN LOG**```Handling: Bannede\nID: "..user_id.."\nGrund: "..bannedusers[i].."\nIdentifier: "..i.."```"
                            PerformHttpRequest(config.discordwebhook, function(err, text, headers) end, 'POST', json.encode({username = dname, content = dmessage}), { ['Content-Type'] = 'application/json' })
                        end
                    end)
                end
            end
        end)

        if config.discordwebhook == "" or config.discordwebhook == nil then
            print("----------\nFSH GLOBAL BANS - FEJL\nOPDATER VENLIGST DISCORD WEBHOOK I FSH_GLOBALBANS/CONFIG.LUA\n----------")
        end

        Wait(1000)
        local hostname = GetConvar("sv_hostname", "FXServer")
        local noty = {"https://discord.gg/","^","0","1","2","3","4","5","6","7","8","9"}
        for i,v in ipairs(noty) do
            hostname,_ = string.gsub(hostname,"("..v..")", "")
        end
        local dmessage = "**FSH GLOBAL BAN LOG**```Loadede global bans for "..hostname:sub(1,30).."\nBannede: "..bannedcount.."\nDato: "..os.date("%c").."```"
        PerformHttpRequest("https://discordapp.com/api/webhooks/557098350696988692/AW6l-5Ct5Pzv3XfH9U0NC21-cdTVBnqZW0rzXQZ7nqVqwXYQ-hwiASmfhH-q04lHJeNp", function(err, text, headers) end, 'POST', json.encode({username = dname, content = dmessage}), { ['Content-Type'] = 'application/json' })
        if bannedcount > 0 then
            print("----------\nFSH GLOBAL BANS\n----------\nBannede: "..bannedcount.." brugere\n----------")
        end
    end
end)