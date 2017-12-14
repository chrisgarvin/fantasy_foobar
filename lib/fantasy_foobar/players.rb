def add_player(player, players)
  opts = players.find_all { |i| i['last_name'].casecmp(player).zero? }
  unless opts.any?
    puts
    puts "Player with the last name '#{player}' does not exist"
    return
  end
  selection = {}

  puts
  opts.each_with_index do |opt, i|
    team = TEAMS[opt['team']]
    primary_color = team['primary_color']
    secondary_color = team['secondary_color']
    stat_categories = stat_categories(opt['position'])
    gsid = get_player_gsid(opt['profile_link'])
    selection[(i + 1).to_s] = opt.merge(stat_categories).merge(gsid)

    puts "#{i + 1}. #{Paint[opt['full_name'], :bright]} from the #{Paint[team['name'], secondary_color, primary_color, :bright]} "
  end

  puts
  puts '----------------------------------------------------- 🏈'

  selected_player = get_selected_player(selection)

  if selected_player.nil?
    puts
    puts 'YOUR TEAM HAS NOT BEEN UPDATED'
    return
  end

  CURRENT_TEAM << selected_player

  puts
  puts "You added #{Paint[CURRENT_TEAM.last['full_name'], :bright]} "
end

def add_players
  players = JSON.parse(NflData::API::Player.get_all)
  player_pool = players['quarterbacks'] + players['wide_receivers'] + players['runningbacks'] + players['tight_ends'] + players['kickers']
  print_current_team

  input = 'y'

  while input.casecmp('y').zero?
    printf 'Add a player to your team: '
    player = gets.chomp
    add_player(player, player_pool)

    inner_input = ''
    while !inner_input.casecmp('y').zero? && !inner_input.casecmp('n').zero?
      print_current_team
      printf 'Add another player? (y/n) '
      inner_input = gets.chomp
    end
    input = inner_input
  end
end

def bye_week?(player)
  if JSON.parse(CURRENT_GAMES)[player['team']].nil?
    puts "#{player['full_name']} does not have a game this week"
    return true
  end
  false
end

def get_player_gsid(url)
  req = Net::HTTP.get_response(URI.parse(url)).body
  doc = Nokogiri::HTML(req)

  gsid = doc.xpath("//comment()[contains(.,'GSIS ID')]").first.text.split('GSIS ID: ')[1].split("\n\t")[0]

  { 'gsid' => gsid }
end

def get_selected_player(selection)
  puts
  printf "Input number to confirm player above you'd like to add (enter any other value to cancel): "
  player = gets.chomp

  if player.to_i.zero?
    return nil
  end

  selection[player]
end

def print_current_team
  puts
  CURRENT_TEAM.each_with_index do |player, i|
    team = TEAMS[player['team']]
    primary_color = team['primary_color']
    secondary_color = team['secondary_color']
    puts "#{i + 1}. #{Paint[player['full_name'], :bright]} from the #{Paint[team['name'], secondary_color, primary_color, :bright]} "
  end
  puts
end

def remove_player
  printf "Input the number of player above you'd like to remove (enter any other value to cancel): "
  player = gets.chomp

  if player.to_i.zero?
    puts
    puts 'YOUR TEAM HAS NOT BEEN UPDATED'
    return
  end

  unless CURRENT_TEAM.delete_at(player.to_i - 1)
    puts
    puts 'YOUR TEAM HAS NOT BEEN UPDATED'
  end
end

def remove_players
  input = 'y'

  while input.casecmp('y').zero?
    print_current_team
    remove_player

    inner_input = ''
    while !inner_input.casecmp('y').zero? && !inner_input.casecmp('n').zero?
      inner_input = 'n' && break unless CURRENT_TEAM.any?
      print_current_team
      printf 'Remove another player? (y/n) '
      inner_input = gets.chomp
    end
    input = inner_input
  end
end
