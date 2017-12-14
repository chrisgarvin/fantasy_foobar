require 'nfl_data'

module NflData
  class PlayerParser
    include ParserHelper

    attr_reader :base_url

    def initialize
      @base_url = 'http://www.nfl.com/players/search?category=position&conferenceAbbr=null&playerType=current&conference=ALL&filter='
    end

    def get_by_position(position)
      if position == :all
        {
          quarterbacks: get('quarterback'),
          runningbacks: get('runningback'),
          wide_receivers: get('widereceiver'),
          tight_ends: get('tightend'),
          kickers: get('kicker')
        }
      else
        { position => get(position.to_s.gsub(/s|_/, '')) }
      end
    end
  end
end
