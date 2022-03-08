# frozen_string_literal: true

RSpec.describe Feedproxy do
  it "has a version number" do
    expect(Feedproxy::VERSION).not_to be nil
  end

  context "when loading a feed" do
    before do
      @feed_links = [
        'https://feeds.simplecast.com/EOAFriME',
        'https://world.hey.com/this.week.in.rails/feed.atom',
      ]

      VCR.insert_cassette('download_feeds', {record: :new_episodes})
    end

    it "must have items" do
      @feed_links.each do |feed_link|
        feed = Feedproxy::Feed.new(feed_link)
        expect(feed.items.to_a.size).to be > 0
      end
    end

    it "items must have populated attributes" do
      @feed_links.each do |feed_link|
        feed = Feedproxy::Feed.new(feed_link)
        message = "Failure in feed link: #{feed_link}"
        feed.items.each do |item|
          expect(item.uuid).to_not be_nil, message
          expect(item.summary).to_not be_nil, message
          expect(item.description).to_not be_nil, message
          expect(item.published_at).to_not be_nil, message

          expect(item.link).to_not eq(""), message
          expect(item.uuid).to_not eq(""), message
          expect(item.summary).to_not eq(""), message
          expect(item.description).to_not eq(""), message
          expect(item.link).to_not eq(""), message
        end
      end
    end

    after do
      VCR.eject_cassette
    end
  end
end
