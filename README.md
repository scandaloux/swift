# Swift

Swift is a minimal and extremely easy to use http framework for [Lune](https://github.com/scandaloux/swift/blob/main/Lune).
It's based on NodeJS libraries such as Express and Fastify.

**Swift is in a barebones stage, so it's pretty simple and lacking right now. I can't confirm if I will continue this project, but we'll see**

```luau
local Swift = require("swift/index")

local server = Swift.server.new()

server:get("/", function(req, rep)
  rep:send("Hello from Swift!")
end)

server:listen(8080, function()
  print("Server is running on port 8080")
end)
```

# Examples

<details>
  <summary>Routes</summary>

  Routes are a way of splitting different paths into a modular layout.
  
  ###### route.luau
  ```luau
  local Swift = require("swift/index")

  local route = Swift.route.new()

  route:get("/", function(req, rep)
    rep:send("This is my other route! You should totally check out /route/path")
  end)

  route:get("/path", function(req, rep)
    rep:send("This is my other path!")
  end)

  return route
  ```

  ###### index.luau
  ```luau
  local Swift = require("swift/index")
  local route = require("route")

  local server = Swift.server.new()

  server:register("/route", route)

  server:get("/", function(req, rep)
    rep:send("Hey, you shoud totally check out /route")
  end)

  server:listen(8080, function()
    print("Listening on port 8080")
  end)
  ```
</details>

# Installation

I haven't really gotten any proper installation for this yet, so just download the sourcecode and copy the src folder into a project, and rename it to swift.
This means you will have to require with "swift/index"
