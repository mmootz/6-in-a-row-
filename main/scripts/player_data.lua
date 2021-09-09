-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.


function save_score(Table,player,round,save_score,new_round)
    if new_round == true then 
        Table[round] = {}
        return Table  
    end
    Table[round][player] = save_score
    return Table
end 


function get_score(aTable,player,score)
    
    -- print("Score:" .. score) 
    -- print_r(aTable)
    total = score 
    for key, value in pairs(aTable) do 
        if(type(value) == "table") then 
            get_score(value,player,total)
            -- print("table:" .. tostring(value))
            -- print(player)
        else
            if key == player then 
                total = value + total
                print("get_score: " .. player)
            end
        end
    end
    
    return total
end

local function load_scoredb()
    local filename = sys.get_save_file("end_game_filename", "end_game") -- <1>
    local data = sys.load(filename) 
    return data
end

local function find_12s(aTable,max)
    total = max
    for key, value in pairs(aTable) do 
        if(type(value) == "table") then 
            find_12s(value,total)
        else
            if value >= 12 then 
                total = total + 1
                player = key 
            end
        end
    end
    return total , player
end

function get_winner()
    local temp = {}
    local high_score
    local player 
    find_winner = load_scoredb()
    high_score = 0
    player = ""
    print_r(find_winner)
    for index, data in ipairs(find_winner) do
        temp[data] = get_score(find_winner,data,0)
        print("data" .. tostring(data))
    end
    for key,value in pairs(temp) do
        if high_score < value then 
            high_score = value 
            player = key
        end
    end
    print("score: " .. high_score .."Player: " .. player )
    return high_score, player
end



-- pass players (lua table) and save it.
function save_data(players)
	local filename = sys.get_save_file("playerfilename", "players")
	
	local path_to_file = sys.get_save_file("6 in a row", "dummy_test")
	print(path_to_file)
	sys.save(filename, players ) 
end

function finish_game(end_game)
    local filename = sys.get_save_file("end_game_filename", "end_game")
    sys.save(filename, end_game)
end 


function print_users(players)

	for index, data in ipairs(players) do
		print("Player:" .. index .. " " .. data .. " saved...")
	end

end

function load_users()
	local filename = sys.get_save_file("playerfilename", "players") -- <1>
	local data = sys.load(filename) 
	return data
end


function add_users(players,player_name)
		print("add user:" .. new_player)
		local load_players = load_users()
		table.insert(load_players, new_player)
		save_data(load_players)
end

-- function remove_users(player_index)
-- 	local players = load_users()
-- 	print(players[player_index])
-- end 


function print_r(arr, indentLevel)
	local str = ""
	local indentStr = "#"

	if(indentLevel == nil) then
		print(print_r(arr, 0))
		return
	end

	for i = 0, indentLevel do
		indentStr = indentStr.."\t"
	end

	for index,value in pairs(arr) do
		if type(value) == "table" then
			str = str..indentStr..index..": \n"..print_r(value, (indentLevel + 1))
		else 
			str = str..indentStr..index..": "..value.."\n"
		end
	end
	return str
end

function next_player(player_name,players)	
	player_size = 0 
	for _ in pairs(players) do player_size = player_size + 1 end

	for k, v in next, players do
		if v == player_name then 
			match = k     
		end  
	end

	if match == player_size then 
		return players[1]
	end 

	next_player = next(players,match)
	return players[next_player]

end 



