module TweepTalk

  class Convos

    def initialize(twitter)
      @twitter = twitter
    end

    def convo_from(tweet)
      @twitter.replies(tweet).inject([tweet]) { |tweets, t| tweets + convo_from(t) }
    end

    def convos
      result = []

      @twitter.home_timeline.each do |t|
        puts t
        thread = result.find {|x| x.first.in_reply_to_status_id? && x.first.in_reply_to_status_id == t.id }
        if thread
          thread << t
          puts "adding to thread: #{thread}"
        elsif t.in_reply_to_status_id?
          result << [t]
          puts "adding to result: #{result}"
        end

      end

      result
    end

  end

end