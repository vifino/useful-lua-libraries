random = {}
function random.seed()
  math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) )
end
return random