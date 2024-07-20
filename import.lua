local registeredEvent, CONTEXT = {}, IsDuplicityVersion() and 'server' or 'client';

if CONTEXT == 'server' then
  ---@param eventName string
  ---@param playerId number | string
  function TriggerClientEvent(eventName, playerId, ...)
    ---@diagnostic disable-next-line: cast-local-type
    playerId = tonumber(playerId);

    if not playerId or playerId < 0 and playerId ~= -1 then
      error('Argument `playerId` is not valid.', 3);
    end

    if playerId == -1 then
      GlobalState:set('__event:client:' .. eventName, { ... }, true);
    else
      Player(playerId).state:set('__event:client:' .. eventName, { ... }, true);
    end
  end
else
  ---@param eventName string
  function TriggerServerEvent(eventName, ...)
    LocalPlayer.state:set('__event:server:' .. eventName, { ... }, true);
  end
end

---@param eventName string
function TriggerEvent(eventName, ...)
  GlobalState:set('__event:' .. CONTEXT .. ':' .. eventName, { ... }, false);
end

---@param eventName string
---@param cb fun(...): any
---@return { key: number; name: string }
function AddEventHandler(eventName, cb)
  ---@param bagName string
  ---@param bagKey string
  ---@param bagValue any
  local key = AddStateBagChangeHandler('__event:' .. CONTEXT .. ':' .. eventName, '', function(bagName, bagKey, bagValue)
    local _, context = string.strsplit(':', bagKey);

    if not bagKey:find('^__event') or (CONTEXT ~= context and not registeredEvent[eventName]) then
      return;
    end

    if CONTEXT == 'server' and bagName ~= 'global' then
      _G.source = GetPlayerFromStateBagName(bagName);
    end

    cb(table.unpack(bagValue));
  end);

  return {
    key = key,
    name = eventName
  };
end

---@param eventName string
---@param cb? fun(...): any
---@return { key: number; name: string }?
RegisterNetEvent = function(eventName, cb)
  registeredEvent[eventName] = true;

  if not cb then
    return;
  end

  return AddEventHandler(eventName, cb);
end;

---@param eventData { key: number; name: string }
function RemoveEventHandler(eventData)
  RemoveStateBagChangeHandler(eventData.key);
end
