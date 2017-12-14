require 'fantasy_foobar/app_flow'
require 'fantasy_foobar/players'
require 'fantasy_foobar/stats'
require 'fantasy_foobar/version'
require 'fantasy_foobar/kickers_included'

module FantasyFoobar
  class Team
    def start_app
      if update_team?
        remove_players if CURRENT_TEAM.any? && remove_players?
        add_players if add_players?

        File.write("#{FILE_PATH}/lib/fantasy_foobar/data/current_team.json", CURRENT_TEAM.to_json)
      end

      puts
      print_stats
    end
  end
end
