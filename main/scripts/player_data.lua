-- functions used by script to pass data between screens

function save_score(Table,player,round,save_score,new_round)
    if new_round == true then 
        Table[round] = {}
        return Table  
    end
    Table[round][player] = save_score
    return Table
end 


function get_player_index(name)
    local player_index = load_users()
    for index,value in ipairs(player_index) do
        if name == value then 
            found_index = index 
        end
    end
    return found_index
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

local function load_scoredb()
    local filename = sys.get_save_file("game_score", "current") -- <1>
    local data = sys.load(filename) 
    return data
end

-- used by get winner below to find high_score for user

function get_score(aTable,player,score)
    total = score 
    for key, value in pairs(aTable) do 
        if(type(value) == "table") then 
            get_score(value,player,total)
        else
            if key == player then 
                total = value + total
            end
        end
    end

    return total
end



-- looks for winner by checking user with highest score 
-- function get score is used to find users score 
function get_winner(scores_table)
    local temp = {}
    local high_score
    local player 
    high_score = 0
    player = ""
    temp = {}
    players = load_scoredb()
    for index, data in pairs(players) do
        if (type(data) == "table") then
            for key, value in pairs(data) do
                if temp[key] == nil then 
                    temp[key] = 0 
                end 
                temp_data = 0
                temp_num = 0
                temp_data  = get_score(data,key,0)
                temp_num = temp[key]
                temp[key] = temp_data + temp_num
            end
        end 
    end

    for key,value in pairs(temp) do
        if high_score < value then 
            high_score = value 
            player = key
        end
    end
    return high_score, player
end

-- pass players (lua table) and save it.
function save_data(players)
    local filename = sys.get_save_file("playerfilename", "players")
    local path_to_file = sys.get_save_file("6 in a row", "dummy_test")
    sys.save(filename, players ) 
end

function save_active_players(players)
    local filename = sys.get_save_file("activeplayers", "players")
    sys.save(filename, players ) 
end




function save_stats(score_table)    
    local save_time = os.date()
    local stats_table = load_stats()
    stats_table[save_time] = {}
    table.insert(stats_table[save_time], score_table)
    local filename = sys.get_save_file("stats", "stats_save")
    sys.save(filename, stats_table ) 

end

function save_stats_top( name, value, player)
    local stats_table = load_stats()
    stats_table[name] = {}
    table.insert(stats_table[name], { value , player })
    local filename = sys.get_save_file("stats", "stats_save")
    sys.save(filename, stats_table) 
end



function load_active_players()
    local filename = sys.get_save_file("activeplayers", "players") -- <1>
    local data = sys.load(filename) 
    return data
end


function finish_game(end_game)
    local filename = sys.get_save_file("game_score", "current")
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

function check_stats_top(name, checked_value)
    local stats_table = load_stats()
    if stats_table[name][1][1] < checked_value then 
        return true
    else 
        return false 
    end
end

function load_stats() 
   local filename = sys.get_save_file("stats", "stats_save")
   local data = sys.load(filename)
   -- data = {}
   -- data['highscore'] = 202 
   -- data['streak'] = 2
   -- data['twelves'] = 3
   return data 
    
end 





