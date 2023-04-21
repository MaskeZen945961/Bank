--Script by MaskeZen (https://github.com/MaskeZen945961)
ESX = nil 
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

numero = nil

RegisterServerEvent('ConnecterCompte')
AddEventHandler('ConnecterCompte', function(numero, mdp)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local numero = numero
    local mdp = mdp

    MySQL.Async.fetchAll('SELECT * FROM bank_account WHERE account_number = @account_number AND account_password = @account_password', {
        ['@account_number'] = numero,
        ['@account_password'] = mdp
    }, function(result)
        if result[1] ~= nil then
            money10 = result[1].money
            typecompte = result[1].typecompte
            TriggerClientEvent('esx:showNotification', _source, 'Vous êtes connecté au compte ~g~' .. numero)
            addtohistorique("Connexion", numero)
            TriggerClientEvent('Bank:OpenMenu', _source ,numero , money10, typecompte)
        else
            TriggerClientEvent('esx:showNotification', _source, 'Le compte ~r~' .. numero .. ' ~s~n\'existe pas ou le mot de passe est incorrect')
            TriggerClientEvent('Bank:Incorect', _source)
        end
    end)
end)

RegisterServerEvent('ChangerMdp')
AddEventHandler('ChangerMdp', function(newmdp, numero)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local numero = numero
    local mdp = mdp

    MySQL.Async.execute('UPDATE bank_account SET account_password = @newmdp WHERE account_number = @numero', {
        ['@newmdp'] = newmdp,
        ['@numero'] = numero
    }, function(rowsChanged)
        if rowsChanged > 0 then
            addtohistorique("Changement mot de passe -", numero)
            TriggerClientEvent('esx:showNotification', _source, 'Le mot de passe du compte ~g~' .. numero .. ' ~s~a été modifié en ~o~'.. newmdp ..'')
        else
            TriggerClientEvent('esx:showNotification', _source, 'Le mot de passe du compte ~r~' .. numero .. ' ~s~n\'a pas été modifié.')
        end
    end)


end)

RegisterServerEvent('RetirerArgent')
AddEventHandler('RetirerArgent', function(amount, numero, mdp)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local numero = numero
    local mdp = mdp
    local amount = amount
    
    MySQL.Async.fetchScalar('SELECT money FROM bank_account WHERE account_number = @numero', {
        ['@numero'] = numero
    }, function(result)
        if result ~= nil and tonumber(result) >= tonumber(amount) then
            MySQL.Async.execute('UPDATE bank_account SET money = money - @amount WHERE account_number = @numero', {
                ['@amount'] = amount,
                ['@numero'] = numero
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    addtohistorique("Retirer " .. amount .. "$ ", numero)
                    TriggerClientEvent('esx:showNotification', source, 'Vous avez retiré ' .. amount .. '$ du compte ' .. numero)
                    xPlayer.addMoney(amount)
                else
                    TriggerClientEvent('esx:showNotification', source, 'Impossible de retirer ' .. amount .. '$ du compte ' .. numero)
                end
            end)
        else
            TriggerClientEvent('esx:showNotification', source, 'Impossible de retirer ' .. amount .. '$ du compte ' .. numero)
        end
    end)
end)


RegisterServerEvent('DeposerArgent')
AddEventHandler('DeposerArgent', function(amount, numero)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local numero = numero
    local amount = amount
    MySQL.Async.execute('UPDATE bank_account SET money = money + @amount WHERE account_number = @numero', {
        ['@amount'] = amount,
        ['@numero'] = numero
    }, function(rowsChanged)
        if rowsChanged > 0 then
            addtohistorique("Déposer " .. amount .. "-", numero)
            TriggerClientEvent('esx:showNotification', source, 'Vous avez déposé ' .. amount .. '$ sur le compte ' .. numero)
            xPlayer.removeMoney(amount)
        else
            TriggerClientEvent('esx:showNotification', source, 'Impossible de déposer ' .. amount .. '$ sur le compte ' .. numero)
        end
    end)
end)






RegisterServerEvent('FermerCompte')
AddEventHandler('FermerCompte', function(numero)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local numero = numero
    local amount = amount
    MySQL.Async.execute('DELETE FROM bank_account WHERE account_number = @numero', {
        ['@numero'] = numero
    }, function(rowsChanged)
        if rowsChanged > 0 then
            TriggerClientEvent('esx:showNotification', source, 'Le compte ~r~' .. numero .. ' ~s~a été supprimé.')
        else
            TriggerClientEvent('esx:showNotification', source, 'Le compte ~r~' .. numero .. ' ~s~n\'a pas été supprimé.')
        end
    end)


end)

RegisterNetEvent('Virement')
AddEventHandler('Virement', function(amount, numero, numero2)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local numero = numero
    local numero2 = numero2
    local amount = amount
    MySQL.Async.fetchScalar('SELECT money FROM bank_account WHERE account_number = @numero', {
        ['@numero'] = numero
    }, function(result)
        if result ~= nil and tonumber(result) >= tonumber(amount) then
            MySQL.Async.execute('UPDATE bank_account SET money = money - @amount WHERE account_number = @numero', {
                ['@amount'] = amount,
                ['@numero'] = numero
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    MySQL.Async.execute('UPDATE bank_account SET money = money + @amount WHERE account_number = @numero', {
                        ['@amount'] = amount,
                        ['@numero'] = numero2
                    }, function(rowsChanged)
                        if rowsChanged > 0 then
                            addtohistorique("Virement " .. amount .. "$ vers " .. numero2, numero)
                            TriggerClientEvent('esx:showNotification', source, 'Vous avez viré ' .. amount .. '$ du compte ' .. numero .. ' vers le compte ' .. numero2)
                        else
                            TriggerClientEvent('esx:showNotification', source, 'Impossible de virer ' .. amount .. '$ du compte ' .. numero .. ' vers le compte ' .. numero2)
                        end
                    end)
                else
                    TriggerClientEvent('esx:showNotification', source, 'Impossible de virer ' .. amount .. '$ du compte ' .. numero .. ' vers le compte ' .. numero2)
                end
            end)
        else
            TriggerClientEvent('esx:showNotification', source, 'Impossible de virer ' .. amount .. '$ du compte ' .. numero .. ' vers le compte ' .. numero2)
        end
    end)
end)


RegisterNetEvent('CreerCompte')
AddEventHandler('CreerCompte', function(numero, mdp, typecompte)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local numero = numero
    local amount = amount
    local typecompte = typecompte
    MySQL.Async.fetchScalar('SELECT COUNT(*) FROM bank_account WHERE account_number = @numero', {
        ['@numero'] = numero
    }, function(count)
        if count > 0 then
            TriggerClientEvent('esx:showNotification', source, 'Le compte ~r~' .. numero .. ' ~s~existe déjà.')
        else
            MySQL.Async.execute('INSERT INTO bank_account (account_number, account_password, money, typecompte, createby) VALUES (@numero, @mdp, @money, @typecompte, @createby)', {
                ['@numero'] = numero,
                ['@mdp'] = mdp,
                ['@createby'] = xPlayer.identifier,
                ['@typecompte'] = typecompte,
                ['@money'] = 0
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    xPlayer.removeMoney(2500)
                    TriggerClientEvent('esx:showNotification', source, 'Le compte ~g~' .. numero .. ' ~s~a été créé.')
                else
                    TriggerClientEvent('esx:showNotification', source, 'Le compte ~r~' .. numero .. ' ~s~n\'a pas été créé.')
                end
            end)
        end
    end)
    
end)

function addtohistorique(action,numero) 
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local numero = numero
    local action = action
    MySQL.Async.execute('INSERT INTO historique_bank (action,numero) VALUES (@action, @numero)', {
        ['@action'] = action,
        ['@numero'] = numero
    }, function(rowsChanged)
        if rowsChanged > 0 then
            mpmp = true
        else
            mpmp = true
        end
    end)
end

ESX.RegisterServerCallback('gethistorique', function(source, cb, numero)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local numero = numero
    MySQL.Async.fetchAll('SELECT * FROM historique_bank WHERE numero = @numero', {
        ['@numero'] = numero
    }, function(result)
        cb(result)
    end)
end)

RegisterNetEvent('num')
AddEventHandler('num', function(numero)
    local numero = numero
end)

ESX.RegisterServerCallback('getmoney', function(source, cb, numero)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local numero = numero
    MySQL.Async.fetchScalar('SELECT money FROM bank_account WHERE account_number = @numero', {
        ['@numero'] = numero
    }, function(result)
        cb(result)
    end)
end)


