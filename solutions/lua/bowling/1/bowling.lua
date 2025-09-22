local function skip(xs, n)
	local tl = {}
	for i = n+1, #xs do
		table.insert(tl, xs[i])
	end
	return tl
end

return function()
	local state_name = "frame_start"
	local state = nil
	local frames = {}
	local rolls = {}

	local function score_aux(acc, frames, rolls)
		if #frames >= 1 and frames[1] == "open" and #rolls >= 2 then
			return score_aux(acc + rolls[1] + rolls[2], skip(frames, 1), skip(rolls, 2))
		elseif #frames >= 1 and frames[1] == "spare" and #rolls >= 3 then
			return score_aux(acc + 10 + rolls[3], skip(frames, 1), skip(rolls, 2))
		elseif #frames >= 1 and frames[1] == "strike" and #rolls >= 3 then
			return score_aux(acc + 10 + rolls[2] + rolls[3], skip(frames, 1), skip(rolls, 1))
		elseif #frames > 0 then
			error("")
		else
			return acc
		end
	end

	return {
		roll = function(pins)
			local is_last_frame = (#frames + 1) == 10

			if pins < 0 then
				error("negative roll is invalid")
			elseif pins > 10 then
				error("pin count exceeds pins in lane")
			else
				if state_name == "frame_one_more" and assert(state ~= nil) and pins > state.in_lane then
					error("pin count exceeds pins in lane")
				elseif state_name == "bonus_fills" and assert(state ~= nil) and pins > state.in_lane then
					error("pin count exceeds pins in lane")
				elseif state_name == "frame_start" and pins < 10 then
					table.insert(rolls, pins)
					state_name = "frame_one_more"
					state = { in_lane = 10 - pins }
				elseif state_name == "frame_start" and pins == 10 then
					table.insert(rolls, pins)
					if is_last_frame then
						state_name = "bonus_fills"
						state = {
							in_lane = 10,
							fills_left = 2,
						}
					else
						state_name = "frame_start"
						state = nil
					end
					table.insert(frames, "strike")
				elseif state_name == "frame_one_more" and assert(state ~= nil) and pins == state.in_lane then
					table.insert(rolls, pins)
					if is_last_frame then
						state_name = "bonus_fills"
						state = {
							in_lane = 10,
							fills_left = 1,
						}
					else
						state_name = "frame_start"
						state = nil
					end
					table.insert(frames, "spare")
				elseif state_name == "frame_one_more" and assert(state ~= nil) and pins < state.in_lane then
					table.insert(rolls, pins)
					if is_last_frame then
						state_name = "game_ended"
						state = nil
					else
						state_name = "frame_start"
						state = nil
					end
					table.insert(frames, "open")
				elseif state_name == "bonus_fills" and assert(state ~= nil) then
					table.insert(rolls, pins)
					if state.fills_left == 1 then
						state_name = "game_ended"
						state = nil
					else
						state_name = "bonus_fills"
						local new_state = {}
						new_state.fills_left = state.fills_left - 1
						if pins == 10 then
							new_state.in_lane = 10
						else
							new_state.in_lane = state.in_lane - pins
						end
						state = new_state
					end
				elseif state_name == "game_ended" then
					error("cannot roll after game is over")
				else
					error("unreachable")
				end
			end
    end,
    score = function()
			if state_name == "game_ended" then
				return score_aux(0, frames, rolls)
			else
				error("Score cannot be taken until the end of the game")
			end
    end
  }
end
