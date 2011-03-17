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
        convos = convos_for tweet

        if convos.count == 1
          convos[0] << tweet
        elsif convos.count > 1
          merge convos, tweet
        elsif tweet.in_reply_to_status_id?
          @convos << [tweet]
        end

      end

      @convos
    end

    def merge(convos, tweet)
      convos.each {|c| @convos.delete c }
      @convos << convos.flatten + [tweet]
    end

    def convos_for(tweet)
      @convos.find_all do |convo|
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