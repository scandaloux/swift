# Swift

Swift is a minimal and extremely easy to use http framework for [https://github.com/lune-org/lune](Lune).
It's based on NodeJS libraries such as Express and Fastify.

```luau
local Swift = require("swift")

local server = Swift.server.new()

server:get("/", function(req, rep)
  rep:send("Hello from Swift!")
end)

server:listen(8080, function()
  print("Server is running on port 8080")
end)
```
