-- Nullx11 optional external-runtime launcher (not a Roblox LocalScript).
-- Source and the built-in script library use the published main release.
-- Keep the URL in sync if you host a different reviewed version.
-- Review remote code before running it. Prefer pinning a reviewed commit SHA
-- instead of a mutable branch once you publish a version you trust.
local SOURCE_URL =
	"https://raw.githubusercontent.com/Inkflow-Gab/Nullx11-Loader/main/Nullx11.client.luau"

local ok, reason = pcall(function()
	assert(
		type(loadstring) == "function",
		"This runtime does not support client loadstring. Use the full LocalScript in Studio instead."
	)
	local source = game:HttpGet(SOURCE_URL)
	local initialize, compileError = loadstring(source, "Nullx11")
	assert(initialize, compileError or "Could not compile Nullx11")
	initialize()
end)

if not ok then
	warn(
		"[Nullx11] Launch failed: "
			.. tostring(reason)
			.. " — Check that the source URL is published and accessible."
	)
end
