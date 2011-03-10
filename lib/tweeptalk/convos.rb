module TweepTalk

  class Convos

    def initialize(twitter)
      @twitter = twitter
    end

    def convo_from(tweet)
      @twitter.replies(tweet).inject([tweet]) { |tweets, t| tweets + convo_from(t) }
    end

    def convos
      @convos = []

      @twitter.home_timeline.each do |tweet|

        convo = convo_for tweet

        if convo
          convo << tweet
        elsif tweet.in_reply_to_status_id?
          @convos << [tweet]
        end

      end

      @convos
    end

    def convo_for(tweet)
      @convos.find do |convo|
        tweet_is_reply_to_convo(convo, tweet) ||
        convo_contains_tweet_with_same_reply(convo, tweet)
      end
    end

    def tweet_is_reply_to_convo(convo, tweet)
      convo.last.in_reply_to_status_id == tweet.id
    end

    def convo_contains_tweet_with_same_reply(convo, tweet)
      return false unless tweet.in_reply_to_status_id

      convo.find { |t| t.in_reply_to_status_id == tweet.in_reply_to_status_id }
    end

  end

end