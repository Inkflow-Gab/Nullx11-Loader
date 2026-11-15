-- Data-only word index. No fetched source is ever compiled or executed.
return function()
	local dictionary = {
		Words = {},
		Buckets = {},
		White = {},
		Manual = {},
		Black = {},
		Frequency = {},
		Count = 0,
		Revision = 0,
	}
	local bands = {
		Short = { 1, 5 },
		Neutral = { 6, 8 },
		Long = { 9, 12 },
		Longer = { 13, 45 },
	}
	function dictionary.Clean(value, maximum)
		if type(value) ~= "string" then
			return nil
		end
		value = value:lower():match("^%s*(.-)%s*$")
		return #value > 0
				and #value <= (maximum or 45)
				and value:match("^[a-z]+$")
				and value
			or nil
	end
	function dictionary.Add(word)
		word = dictionary.Clean(word)
		if not word or dictionary.Words[word] or dictionary.Count >= 600000 then
			return false
		end
		dictionary.Words[word] = true
		dictionary.Count += 1
		local key = word:sub(1, 1)
		local bucket = dictionary.Buckets[key] or {}
		dictionary.Buckets[key] = bucket
		local lo, hi = 1, #bucket + 1
		while lo < hi do
			local mid = math.floor((lo + hi) / 2)
			if bucket[mid] < word then
				lo = mid + 1
			else
				hi = mid
			end
		end
		table.insert(bucket, lo, word)
		return true
	end
	function dictionary.Load(source, kind, current, yieldNow)
		assert(
			type(source) == "string" and #source > 0 and #source <= 8388608,
			"Word data is empty or exceeds 8 MiB"
		)
		local words, count = {}, 0
		for line in source:gmatch("[^\r\n]+") do
			count += 1
			assert(count <= 600000, "Word data exceeds 600,000 lines")
			local word = dictionary.Clean(line)
			if word then
				words[#words + 1] = word
			end
			if count % 4000 == 0 then
				if current and not current() then
					return false
				end
				if yieldNow then
					yieldNow()
				end
			end
		end
		if current and not current() then
			return false
		end
		-- Bulk-add then sort once, rather than O(n²) insertion for a full dataset.
		for rank, word in ipairs(words) do
			if kind == "frequency" then
				dictionary.Frequency[word] = dictionary.Frequency[word] or rank
			else
				if not dictionary.Words[word] and dictionary.Count < 600000 then
					dictionary.Words[word], dictionary.Count =
						true, dictionary.Count + 1
					local key = word:sub(1, 1)
					dictionary.Buckets[key] = dictionary.Buckets[key] or {}
					table.insert(dictionary.Buckets[key], word)
				end
				if kind == "whitelist" then
					dictionary.White[word] = true
				end
			end
		end
		for _, bucket in pairs(dictionary.Buckets) do
			table.sort(bucket)
		end
		dictionary.Revision += 1
		return true
	end
	function dictionary.Edit(word, action)
		word = assert(
			dictionary.Clean(word),
			"Enter one alphabetic word, maximum 45 letters"
		)
		if action == "whitelist" then
			dictionary.Manual[word], dictionary.White[word], dictionary.Black[word] =
				true, true, nil
			dictionary.Add(word)
		elseif action == "blacklist" then
			dictionary.Manual[word], dictionary.White[word], dictionary.Black[word] =
				nil, nil, true
		elseif action == "unwhite" then
			dictionary.Manual[word], dictionary.White[word] = nil, nil
		elseif action == "unblack" then
			dictionary.Black[word] = nil
		else
			error("Unknown list operation")
		end
		dictionary.Revision += 1
		return word
	end
	local function bandDistance(word, name)
		local band = bands[name] or bands.Neutral
		return math.max(band[1] - #word, 0, #word - band[2])
	end
	function dictionary.Category(word)
		if #word <= 5 then
			return "Short"
		elseif #word <= 8 then
			return "Neutral"
		elseif #word <= 12 then
			return "Long"
		else
			return "Longer"
		end
	end
	function dictionary.Search(prefix, config, used, tried, limit, ignoreSuffix)
		prefix = dictionary.Clean(prefix, 16)
		if not prefix then
			return {}, { Count = 0 }
		end
		config, used, tried = config or {}, used or {}, tried or {}
		local bucket = dictionary.Buckets[prefix:sub(1, 1)] or {}
		local lo, hi = 1, #bucket + 1
		while lo < hi do
			local mid = math.floor((lo + hi) / 2)
			if bucket[mid] < prefix then
				lo = mid + 1
			else
				hi = mid
			end
		end
		local suffixes = {}
		if not ignoreSuffix and type(config.Endings) == "string" then
			for suffix in config.Endings:lower():sub(1, 128):gmatch("[a-z]+") do
				if #suffixes < 8 then
					table.insert(suffixes, suffix)
				end
			end
		end
		local function suffixRank(word)
			if #suffixes == 0 then
				return 1
			end
			for rank, suffix in ipairs(suffixes) do
				if word:sub(-#suffix) == suffix then
					return rank
				end
			end
			return nil
		end
		local function compare(a, b)
			if a.Suffix ~= b.Suffix then
				return a.Suffix < b.Suffix
			end
			if a.Distance ~= b.Distance then
				return a.Distance < b.Distance
			end
			if config.PreferWhite and a.White ~= b.White then
				return a.White
			end
			if config.Sort == "Longest" and #a.Word ~= #b.Word then
				return #a.Word > #b.Word
			end
			if config.Sort == "Shortest" and #a.Word ~= #b.Word then
				return #a.Word < #b.Word
			end
			if config.Sort == "Most common" then
				local first, second =
					dictionary.Frequency[a.Word] or math.huge,
					dictionary.Frequency[b.Word] or math.huge
				if first ~= second then
					return first < second
				end
			end
			if config.Sort == "Z-a" then
				return a.Word > b.Word
			end
			return a.Word < b.Word
		end
		local result, count, scanned = {}, 0, 0
		limit = math.clamp(limit or 24, 1, 100)
		for index = lo, #bucket do
			local word = bucket[index]
			if word:sub(1, #prefix) ~= prefix then
				break
			end
			scanned += 1
			if scanned > 50000 then
				break
			end
			if
				not dictionary.Black[word]
				and not used[word]
				and not tried[word]
			then
				local rank, distance =
					suffixRank(word), bandDistance(word, config.Length)
				if rank and (config.Fallback ~= false or distance == 0) then
					count += 1
					local item = {
						Word = word,
						White = dictionary.White[word] == true,
						Distance = distance,
						Suffix = rank,
					}
					-- Keep only the best N while traversing: no huge candidate sort.
					local at = #result + 1
					for position, previous in ipairs(result) do
						if compare(item, previous) then
							at = position
							break
						end
					end
					if at <= limit then
						table.insert(result, at, item)
						if #result > limit then
							table.remove(result)
						end
					end
				end
			end
		end
		return result,
			{
				Count = count,
				Scanned = math.min(scanned, 50000),
				Truncated = scanned > 50000,
				Fallback = result[1] and result[1].Distance > 0 or false,
			}
	end
	return dictionary
end
