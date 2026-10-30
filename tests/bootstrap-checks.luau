local failures={}
local function capture(message) table.insert(failures,message) end
runBootstrap(nil, {}, capture)
assert(#failures==1 and string.find(failures[1], "does not support client loadstring", 1, true), "unsupported runtime explains install alternative")
runBootstrap(function() end, {HttpGet=function() error("offline") end}, capture)
assert(#failures==2 and string.find(failures[2], "offline", 1, true), "download failure reported")
runBootstrap(function() return nil,"bad source" end, {HttpGet=function() return "invalid" end}, capture)
assert(#failures==3 and string.find(failures[3], "bad source", 1, true), "compile failure reported")
local started=false
runBootstrap(function(source, name)
 assert(source=="reviewed source" and name=="Nullx11")
 return function() started=true end
end, {HttpGet=function(self, url)
 assert(string.find(url, "Nullx11.client.luau", 1, true), "launcher targets client, not itself")
 return "reviewed source"
end}, capture)
assert(started and #failures==3, "downloaded initializer runs")
return "PASS: bootstrap capability, download, compilation, and startup paths (mocked; no network)"
