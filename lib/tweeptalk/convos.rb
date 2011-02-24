module TweepTalk

  class Convos

    def initialize(twitter)
      @twitter = twitter
    end

    def convo_from(tweet)
      { tweets: [tweet] + @twitter.replies(tweet) }      
    end

  end

end