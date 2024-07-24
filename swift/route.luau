local trimPrefix = require("util/trimPrefix")

local Route = {}
Route.__index = Route
Route.__type = "Route"

local function isRoute(obj)
  local objMetatable = getmetatable(obj)
  return objMetatable and objMetatable.__type == "Route"
end

function Route.new()
  local self = {}
  self._structure = {}
  return setmetatable(self, Route)
end

function Route:register(prefix, route)
  assert(prefix, "No prefix defined")
  assert(isRoute(route), "Invalid route - please pass a Route object")

  prefix = trimPrefix(prefix)
  for method, prefixes in route._structure do
    if not self._structure[method] then
      self._structure[method] = {}
    end
    for subprefix, callback in prefixes do
      subprefix = prefix .. subprefix
      if self._structure[method][subprefix] then
        error(`Failed to register Route: {subprefix} is already registered`)
      end
      self._structure[method][subprefix] = callback
    end
  end
end

function Route:path(method, prefix, callback)
  assert(prefix, "No prefix defined")
  assert(callback, "No callback defined")
  assert(self._structure[prefix] == nil, "Prefix already used")

  prefix = trimPrefix(prefix)
  if not self._structure[method] then
    self._structure[method] = {}
  end
  self._structure[method][prefix] = callback
end

function Route:get(...)
  self:path("GET", ...)
end

function Route:head(...)
  self:path("HEAD", ...)
end

function Route:post(...)
  self:path("POST", ...)
end

function Route:put(...)
  self:path("PUT", ...)
end

function Route:delete(...)
  self:path("DELETE", ...)
end

function Route:connect(...)
  self:path("CONNECT", ...)
end

function Route:options(...)
  self:path("OPTIONS", ...)
end

function Route:trace(...) 
  self:path("TRACE", ...)
end

function Route:patch(...) 
  self:path("PATCH", ...)
end

return Route
