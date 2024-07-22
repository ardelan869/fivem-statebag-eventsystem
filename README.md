> [!WARNING]  
> It has been tested, but it still could be unreliable or buggy. Use it at your own risk.

> [!NOTE]
>This is just a fun little project I whipped up in about 10-20 minutes.\
>It might be safer than the normal event system, but I do not promise anything.\
>Executors like Eulen or RedEngine should still be able to trigger the "StateBag-Events" if the user knows the structure.

# fivem-statebag-eventsystem

Uses FiveM's built-in StateBags to route events.\
\
This script/file overwrites `RegisterNetEvent`, `AddEventHandler`, `TriggerEvent`, `TriggerServerEvent`, `TriggerClientEvent`.\
You can use everything like you did before, the only difference is that it "*uses a different routing*".

# Usage

Add the file `@resourceName/import.lua` into the `shared_scripts` section of your desired `fxmanifest.lua`.\
`@resourceName` refers to the name of the resource, name the resource as you desire.

## Example

- fxmanifest.lua
```lua
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

shared_script '@fivem-statebag-eventsystem/import.lua'
client_script 'client.lua'
```

- client.lua
```lua
RegisterNetEvent('test', function(value1, value2)
  print('value1', value1)
  print('value2', value2)
end)

RegisterCommand('test', function()
  TriggerEvent('test', '🐈', '🗣️')
end)
```
