local net = require("@lune/net")
local fs = require("@lune/fs")
local mimeTypes = require("data/minetypes")

local Reply = {}
Reply.__index = Reply

function Reply.new()
  local self = {}
  self.raw = {
    status = 200,
    body = "OK",
    headers = {
      ["Content-Type"] = "text/plain"
    }
  }
  self._sent = false
  return setmetatable(self, Reply)
end

function Reply:code(code)
  self.raw.status = code
  return self
end

function Reply:contentType(type)
  self.raw.headers["Content-Type"] = type
  return self
end

function Reply:json(content)
  assert(self._sent == false, "Already sent")

  self:contentType("application/json")
  self.raw.body = net.jsonEncode(content)
  self.raw.headers["Content-Length"] = tostring(#self.raw.body)
  self._sent = true

  return self
end

function Reply:send(content)
  assert(self._sent == false, "Already sent")

  self:contentType("text/plain")
  self.raw.body = content
  self.raw.headers["Content-Length"] = tostring(#content)
  self._sent = true
  
  return self
end

function Reply:sendFile(path)
  assert(self._sent == false, "Already sent")
  
  local success, content = pcall(fs.readFile, path)
  if not success then
    return self:code(500):send("Internal Server Error: Failed to read file")
  end
  
  local extension = path:match("%.([%w%d]+)$") or ""
  self:extension(extension)

  self.raw.body = content
  self.raw.headers["Content-Length"] = tostring(#content)

  self._sent = true

  return self
end

function Reply:extension(extension)
  local contentType = mimeTypes[extension] or "application/octet-stream"
  self:contentType(contentType)
  return self
end

return Reply