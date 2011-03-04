module TweepTalk

  class Twitter

    def initialize(api = nil)
      @api = api
    end

    def replies(tweet)
      @api.home_timeline.select { |t| t.in_reply_to_status_id == tweet.id }
    end

  end

end
