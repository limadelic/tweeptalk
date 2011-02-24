require File.dirname(__FILE__) + '/spec_helper'

describe "Conversation" do

  tweet = reply = 'chirp'

  it "should involve more than one tweet" do

    twitter = TweepTalk::Twitter.new
    sut = TweepTalk::Convos.new twitter

    mock(twitter).replies(tweet) { [reply] }

    convo = sut.convo_from(tweet)

    convo[:tweets].count.should > 1
  end

  it "should find replies to a tweet" do

    api = Twitter::Client.new
    sut = TweepTalk::Twitter.new api

    mock(api).home_timeline { [reply] }

    sut.replies(tweet).count.should > 0
  end
end