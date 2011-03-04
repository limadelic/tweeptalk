module TweepTalk

  class Convos

    def initialize(twitter)
      @twitter = twitter
    end

    def convo_from(tweet)
      @twitter.replies(tweet).inject([tweet]) { |tweets, t| tweets + convo_from(t) }
    end

  end

end