module TweepTalk

  class Twitter

    def initialize(api = nil)
      @api = api
    end

    def replies(tweet)
      @api.home_timeline
    end

  end

end
