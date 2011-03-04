require File.dirname(__FILE__) + '/spec_helper'

describe "Conversation" do

  before(:each) do

    @tweet = Hashie::Mash.new
    @tweet.id = 1

    @reply = Hashie::Mash.new
    @reply.id = 2
    @reply.in_reply_to_status_id = 1

    @dud = Hashie::Mash.new
    @dud.in_reply_to_status_id = 0

    @reply_to_reply = Hashie::Mash.new
    @reply_to_reply.in_reply_to_status_id = 2

    @twitter = TweepTalk::Twitter.new
    stub(@twitter).replies(anything) { [] }

  end

  it "should start from replies n' get to tweet" do
    pending "next Wed"
  end

  it "should include the replies to the tweet" do

    sut = TweepTalk::Convos.new @twitter

    stub(@twitter).replies(@tweet) { [@reply] }

    sut.convo_from(@tweet).should == [@tweet, @reply]
  end

  it "should include the replies to the replies" do

    sut = TweepTalk::Convos.new @twitter

    stub(@twitter).replies(@tweet) { [@reply] }
    stub(@twitter).replies(@reply) { [@reply_to_reply] }

    sut.convo_from(@tweet).should == [@tweet, @reply, @reply_to_reply]
  end

  it "should find replies to a tweet" do

    api = Twitter::Client.new
    sut = TweepTalk::Twitter.new api

    mock(api).home_timeline { [@dud, @reply, @dud] }

    sut.replies(@tweet).should == [@reply]
  end

  it "should get the home tweets" do
    pending "use to play with api"

    Twitter.configure do |config|
      config.consumer_key = '2hEjJDY3npJ1Rh82Y1Mhtw1'
      config.consumer_secret = '9qSIPPrVIY6udxBFVmprL9zcpVaEaQPmoWijkshrYh00'
      config.oauth_token = '260488693-0ky7I3MQL0qf3ScqjjLCJpf48AIrc84YjEAriiVi71'
      config.oauth_token_secret = '7hF0pWQ27NpP0eEzUIfeRebffwXHBIH3gSjmaoTcIrFQ1'
    end

    Twitter.home_timeline.take(1).each { |t| puts "#{t} - #{t.from_user}: #{t.text}" }
  end
end