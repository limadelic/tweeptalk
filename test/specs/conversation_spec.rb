require File.dirname(__FILE__) + '/spec_helper'

describe "Conversation" do

  it "should involve more than one tweet" do

    twitter = TweepTalk::Twitter.new
    sut = TweepTalk::Convos.new twitter

    tweet = reply = 'chirp'

    mock(twitter).replies(tweet) { [reply] }

    convo = sut.convo_from(tweet)

    convo[:tweets].count.should > 1
  end
end