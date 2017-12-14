STAT_LINE = {}
STAT_CACHE = {}

def calculate_points(stat_category, data)
  case stat_category
  when 'passing' then calculate_passing(data)
  when 'rushing' then calculate_rushing(data)
  when 'receiving' then calculate_receiving(data)
  when 'kicking' then calculate_kicking(data)
  when 'fumbles' then calculate_fumbles(data)
  else 0
  end
end

def calculate_passing(data)
  return 0 if data.empty?
  (data['yds'] * 0.04) + (data['tds'] * 4) + (data['twoptm'] * 2) - (data['ints'] * 2)
end

def calculate_rushing(data)
  return 0 if data.empty?
  (data['yds'] * 0.1) + (data['tds'] * 6) + (data['twoptm'] * 2)
end

def calculate_receiving(data)
  return 0 if data.empty?
  (data['yds'] * 0.1) + (data['tds'] * 6) + (data['twoptm'] * 2) + (data['rec'] * 0.5)
end

def calculate_kicking(data)
  return 0 if data.empty?
  data['xpmade'] + (data['fgm'] * 3) - (data['fga'] - data['fgm'])
end

def calculate_fumbles(data)
  return 0 if data.empty?
  data['lost'] * -2
end

def find_or_create_statline(player)
  STAT_LINE[player['gsid']] ||= {}

  player['stat_categories'].each do |stat|
    STAT_LINE[player['gsid']][stat] ||= {}
  end
end

def print_player_feed(player)
  return if bye_week?(player)

  player_gsid = player['gsid']
  team = TEAMS[player['team']]
  primary_color = team['primary_color']
  secondary_color = team['secondary_color']
  STAT_CACHE[player_gsid] = {}
  eid = JSON.parse(CURRENT_GAMES)[player['team']]['eid']

  loop.with_index do |_, i|
    begin
      data = Net::HTTP.get_response(URI.parse("http://www.nfl.com/liveupdate/game-center/#{eid}/#{eid}_gtd.json")).body
      JSON.parse(data)[eid]['drives'].each do |drive_key, drive_value|
        STAT_CACHE[player_gsid][drive_key] ||= {}

        next if drive_key == 'crntdrv'
        drive_value['plays'].each do |play_key, play_value|
          next if STAT_CACHE[player_gsid][drive_key][play_key]
          STAT_CACHE[player_gsid][drive_key][play_key] = play_value['desc']

          next unless play_value['players'][player_gsid]
          puts Paint[play_value['desc'], secondary_color, primary_color, :bright]
          player['stat_categories'].each do |stat_category|
            updated_statline(player, data, stat_category)
          end
          updated_fantasy_points(player)
        end
      end
    rescue
      i.zero? && (puts "#{player['full_name']}'s game has not yet started")
    end
    sleep 30
  end
end

def print_stats
  threads = []
  CURRENT_TEAM.each do |player|
    threads << Thread.new(player) do |my_player|
      find_or_create_statline(my_player)
      print_player_feed(my_player)
    end
  end

  threads.each(&:join)
end

def stat_categories(pos)
  categories = case pos
    when 'QB' then { 'stat_categories' => %w[passing rushing fumbles] }
    when 'K' then { 'stat_categories' => %w[kicking] }
    when 'TE' then { 'stat_categories' => %w[receiving fumbles] }
    else { 'stat_categories' => %w[receiving rushing fumbles] }
  end
  categories
end

def updated_fantasy_points(player)
  points = 0
  STAT_LINE[player['gsid']].each do |k,v|
    points += calculate_points(k, v)
  end
  STAT_LINE[player['gsid']]['fantasy_points'] = points
  puts "#{player['full_name']}: #{'%g' % ('%.1f' % points)} fantasy points"
end

def updated_statline(player, data, stat_category)
  player_name = "#{player['first_name'][0]}.#{player['last_name']}"
  player_gsid = player['gsid']
  eid = JSON.parse(CURRENT_GAMES)[player['team']]['eid']
  location = JSON.parse(CURRENT_GAMES)[player['team']]['location']
  team_stat_category = JSON.parse(data)[eid][location]['stats'][stat_category]
  return if team_stat_category.nil?
  player_data = team_stat_category[player_gsid]
  return if player_data.nil?

  STAT_LINE[player_gsid] ||= {}
  STAT_LINE[player_gsid][stat_category] = player_data

  result = case stat_category
    when 'passing' then "#{player_name}: #{player_data['cmp']}/#{player_data['att']} for #{player_data['yds']} yards with #{player_data['tds']} touchdowns and #{player_data['ints']} interceptions"
    when 'rushing' then "#{player_name}: #{player_data['att']} attempts for #{player_data['yds']} yards and #{player_data['tds']} touchdowns"
    when 'receiving' then "#{player_name}: #{player_data['rec']} receptions for #{player_data['yds']} yards and #{player_data['tds']} touchdowns"
    when 'kicking' then "#{player_name}: #{player_data['fgm']}/#{player_data['fga']} in FGs and #{player_data['xpmade']}/#{player_data['xpa']} in extra points"
    when 'fumbles' then "#{player_name}: #{player_data['lost']} fumble lost"
    else ''
  end
  puts result
end
