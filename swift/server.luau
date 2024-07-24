local net = require("@lune/net")
local Route = require("route")
local Reply = require("reply")
local trimPrefix = require("util/trimPrefix")

local Server = Route.new()
Server.__index = Server

function Server.new()
  local self = {}
  self.serving = false
  self._serveHandle = nil
  return setmetatable(self, Server)
end

function Server:handleRequest(request)
  local methods = self._structure[request.method]
  if methods then
    local path = trimPrefix(request.path)
    local pathCallback = methods[path]
    if pathCallback then
      local reply = Reply.new(request)
      local raw = pathCallback(request, reply)
      if raw then
        return raw
      end
      return reply.raw
    end
  end
  return {
    status = 404,
    body = "Not Found"
  }
end

function Server:listen(optionsOrPort, callback)
  local options = typeof(optionsOrPort) == "table" and optionsOrPort or {port = optionsOrPort}

  assert(not self.serving, "Already serving, use :stop() to stop serving")
  assert(options.port, "No port defined")

  self.serving = true

  local serveHandle = net.serve(options.port, {
    adress = options.host or "http://0.0.0.0",
    handleRequest = function(request)
      return self:handleRequest(request)
    end
  })

  self._serveHandle = serveHandle

  if callback then 
    callback(serveHandle) 
  end
end

function Server:stop()
  if not self.serving then 
    error("Not serving anything", 2)
  end
  self._serveHandle:stop()
end

return Server