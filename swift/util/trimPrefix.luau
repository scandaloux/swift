return function(prefix)
  if prefix:sub(-1) == "/" then
    prefix = prefix:sub(1, -2)
  end
  return prefix
end