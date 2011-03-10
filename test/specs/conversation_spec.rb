require File.dirname(__FILE__) + '/spec_helper'

describe "Conversation" do

  before(:each) do

    @root = tweet 1
    @reply = tweet 2, 1
    @reply2 = tweet 3, 1
    @reply_to_reply = tweet 0, 2

    @another_root = tweet 100
    @another_reply = tweet 101, 100

    @twitter = Twitter::Client.new
    @sut = TweepTalk::Convos.new @twitter
  end

  def tweet(id = 0, reply = nil)
    t = Hashie::Mash.new
    t.id = id
    t.in_reply_to_status_id = reply
    t
  end

  it "should find 2 tweet convo" do

    mock(@twitter).home_timeline { [tweet, @reply, tweet, @root] }

    convos = @sut.convos

    convos.count.should == 1
    convos[0].should == [@reply, @root]
  end

  it "should find 3 tweet convo" do

    mock(@twitter).home_timeline { [tweet, @reply_to_reply, @reply, tweet, @root] }

    convos = @sut.convos

    convos.count.should == 1
    convos[0].should == [@reply_to_reply, @reply, @root]
  end

  it "should find multiple convos" do

    mock(@twitter).home_timeline do
      [tweet, @another_reply, @reply, tweet, @root, tweet, @another_root]
    end

    convos = @sut.convos

    convos.count.should == 2
    convos[0].should == [@another_reply, @another_root]
    convos[1].should == [@reply, @root]
  end

  it "should find convo with multiple replies to tweet" do

    mock(@twitter).home_timeline do
      [tweet, @reply2, @reply, tweet, @root, tweet]
    end

    convos = @sut.convos

    convos.count.should == 1
    convos[0].should == [@reply2, @reply, @root]
  end

  it "should find convo with 2 levels of replies to tweet" do
    pending "hold ur horses"

    mock(@twitter).home_timeline do
      [tweet, @reply2, @reply_to_reply, @reply, tweet, @root, tweet]
    end

    convos = @sut.convos

    convos.count.should == 1
    convos[0].should == [@reply2, @reply_to_reply, @reply, @root]
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