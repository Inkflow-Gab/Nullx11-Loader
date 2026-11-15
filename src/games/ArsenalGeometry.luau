-- Body-part bounds, not a fixed six-stud box around HRP. Tools/accessories and
-- locally enlarged roots are intentionally excluded. Never flatten behind-camera
-- corners onto the screen: near-plane intersections are omitted for one frame.
local geometry = {}
function geometry.Bounds(camera, parts)
	local left, top, right, bottom =
		math.huge, math.huge, -math.huge, -math.huge
	local count = 0
	for index, part in ipairs(parts) do
		if index > 16 then
			break
		end
		if not part.Parent then
			continue
		end
		local size, frame = part.Size, part.CFrame
		for x = -1, 1, 2 do
			for y = -1, 1, 2 do
				for z = -1, 1, 2 do
					local point = camera:WorldToViewportPoint(
						frame:PointToWorldSpace(
							Vector3.new(
								size.X * x / 2,
								size.Y * y / 2,
								size.Z * z / 2
							)
						)
					)
					if point.Z <= 0.05 then
						return nil
					end
					left, top = math.min(left, point.X), math.min(top, point.Y)
					right, bottom =
						math.max(right, point.X), math.max(bottom, point.Y)
					count += 1
				end
			end
		end
	end
	if
		count == 0
		or right < 0
		or bottom < 0
		or left > camera.ViewportSize.X
		or top > camera.ViewportSize.Y
	then
		return nil
	end
	return left, top, right, bottom
end
-- All 2D ESP primitives share a direct, unscaled ScreenGui canvas. Compensate
-- its measured origin (including executor/device layout) in one place.
function geometry.Canvas(point, canvas, offsetX, offsetY)
	local origin = canvas.AbsolutePosition
	local scale = canvas.AbsoluteSize
	if scale.X <= 0 or scale.Y <= 0 then
		return Vector2.new(point.X + offsetX, point.Y + offsetY)
	end
	return Vector2.new(
		point.X - origin.X + offsetX,
		point.Y - origin.Y + offsetY
	)
end
return geometry
