--Script by MaskeZen (https://github.com/MaskeZen945961)
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


mdp = nil
money = 0
numero = 0
typecompte = "silver"
historique = nil
BankingTransac = {}
historique = {}


RMenu.Add('Bank', 'mainBank', RageUI.CreateMenu("Bank", "Bank"))
RMenu.Add('Bank', 'subBank', RageUI.CreateSubMenu(RMenu:Get('Bank', 'mainBank'), "Bank", "Bank"))
RMenu.Add('Bank', 'creerBank', RageUI.CreateSubMenu(RMenu:Get('Bank', 'subBank'), "Bank", "Bank"))
RMenu.Add('Bank', 'Historique', RageUI.CreateSubMenu(RMenu:Get('Bank', 'subBank'), "Bank", "Bank"))



Citizen.CreateThread(function()

    while true do
        
        RageUI.IsVisible(RMenu:Get('Bank', 'mainBank'), function()
            RageUI.Separator("↓ ~b~ Bank ~s~↓")
            RageUI.Line()
            RageUI.Button('Connecter a un compte', nil, { RightLabel = "→→→" }, true, {
                onSelected = function()
                    numero = KeyboardInput("Numero de compte", "Numero de compte")
                    mdp = KeyboardInput("Mot de passe", "Mot de passe")
                    if numero == nil or mdp == nil then
                        TriggerEvent('esx:showNotification', 'Vous devez rentrer un numero de compte et un mot de passe')
                    end
                    RageUI.CloseAll()
                    TriggerServerEvent('ConnecterCompte', numero, mdp)
                end
            })
            RageUI.Button('Creer un compte', nil, { RightLabel = "→→→" }, true, {
                onSelected = function()

                end
            }, RMenu:Get('Bank', 'creerBank'))

            if numero ~= 0 then
                RageUI.Button('Se reconnecter au compte ~g~' .. numero .. '', nil, { RightLabel = "→→→" }, true, {
                    onSelected = function()
                        RageUI.CloseAll()
                        TriggerServerEvent('ConnecterCompte', numero, mdp)
                    end
                })
            end

        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('Bank', 'creerBank'), function()
            RageUI.Separator("↓ ~b~ Bank ~s~↓")
            RageUI.Line()
            RageUI.Button('Compte Silver', nil, { RightLabel = "~g~2500 $" }, true, {
                onSelected = function()
                    numero = KeyboardInput("Numero de compte", "Numero de compte")
                    mdp = KeyboardInput("Mot de passe", "Mot de passe")
                    typecompte = "silver"
                    RageUI.CloseAll()
                    TriggerServerEvent('CreerCompte', numero, mdp, typecompte)
                end
            })


        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('Bank', 'Historique'), function()
            RageUI.Separator("↓ ~b~ Bank ~s~↓")
            RageUI.Line()
        

            for i = 1, #BankingTransac, 1 do
                RageUI.Button(BankingTransac[i].action .. "", nil, { RightLabel = "" }, true, {
                    onSelected = function()
                    end
                })

            end


        end, function()
        end)
        


        RageUI.IsVisible(RMenu:Get('Bank', 'subBank'), function()
            RageUI.Separator("↓ ~b~ Solde ~s~↓")
            RageUI.Line()
            RageUI.Button('Argent sur le compte : ~g~'.. money ..'$', nil, { RightLabel = "" }, true, {
                onSelected = function()
                end
            })
            RageUI.Button('Numero du compte : ~g~'.. numero ..'', nil, { RightLabel = "" }, true, {
                onSelected = function()
                end
            })
            RageUI.Button('Type du compte : ~g~'.. typecompte ..'', nil, { RightLabel = "" }, true, {
                onSelected = function()
                end
            })
            
            RageUI.Separator("↓ ~b~ Action ~s~↓")
            RageUI.Line()
            RageUI.Button('Retirer de l\'argent', nil, { RightLabel = "→→→" }, true, {
                onSelected = function()
                    local amount = KeyboardInput("Montant", "Montant")
                    TriggerServerEvent('RetirerArgent', amount, numero, mdp)
                end
            })

            RageUI.Button('Deposer de l\'argent', nil, { RightLabel = "→→→" }, true, {
                onSelected = function()
                    local amount = KeyboardInput("Montant", "Montant")
                    TriggerServerEvent('DeposerArgent', amount, numero)
                end
            })

            RageUI.Button('Virement', nil, { RightLabel = "→→→" }, true, {
                onSelected = function()
                    local amount = KeyboardInput("Montant", "Montant")
                    local numero2 = KeyboardInput("Numero du compte", "Numero du compte")
                    TriggerServerEvent('Virement', amount, numero, numero2)
                end
            })

            RageUI.Button('Historique', nil, { RightLabel = "→→→" }, true, {
                onSelected = function()
                    BankingTransac = {}
                    GetBankingTransac()

                end
            }, RMenu:Get('Bank', 'Historique'))
            RageUI.Separator("↓ ~b~ Paramettre ~s~↓")
            RageUI.Line()
            RageUI.Button('~o~Changer le mot de passe', nil, { RightLabel = "→→→" }, true, {
                onSelected = function()
                    local newmdp = KeyboardInput("Nouveau mot de passe", "Nouveau mot de passe")
                    TriggerServerEvent('ChangerMdp', newmdp, numero)
                end
            })
            RageUI.Button('~r~Supprimer le compte', nil, { RightLabel = "→→→" }, true, {
                onSelected = function()
                    local motdepassaisie = KeyboardInput("Votre Mot de passe", "Votre Mot de passe")
                    if motdepassaisie == mdp then
                        local sur = KeyboardInput("Etes vous sur ? (oui/non)", "Etes vous sur ? (oui/non)")
                        if sur == "oui" then
                            TriggerServerEvent('FermerCompte', numero)
                        else
                            TriggerEvent('esx:showNotification', 'Vous n\'avez pas fermé le compte')
                        end
                    else
                        TriggerEvent('esx:showNotification', 'Mot de passe incorrect')
                    end

                end
            })



        end, function()
        end)
        Citizen.Wait(0)
    end
end)


function OpenMenuBank()
    RageUI.Visible(RMenu:Get('Bank', 'mainBank'), not RageUI.Visible(RMenu:Get('Bank', 'mainBank')))
end
function OpenMenuBankConnect()
    RageUI.Visible(RMenu:Get('Bank', 'subBank'), not RageUI.Visible(RMenu:Get('Bank', 'subBank')))
end


RegisterNetEvent('Bank:OpenMenu')
AddEventHandler('Bank:OpenMenu', function(numero_arg, money_arg, typecompte_arg)
    money = money_arg
    numero = numero_arg
    typecompte = typecompte_arg
    OpenMenuBankConnect()
end)

RegisterNetEvent('Bank:Incorect')
AddEventHandler('Bank:Incorect', function()
    numero = 0
end)

function GetBankingTransac()
    TriggerServerEvent('num', numero)
    ESX.TriggerServerCallback('gethistorique', function(historique)
        for k,v in pairs(historique) do
            table.insert(BankingTransac, {
                action = v.action,
            })
        end
    end, numero)
end


Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        if numero ~= 0 then
            ESX.TriggerServerCallback('getmoney', function(money_arg)
                money = money_arg
            end, numero)
        end
        Citizen.Wait(sleep)
    end
end)
