module Feedproxy
  class Feed
    class Item
      def initialize(element)
        @element = element
      end

      def to_h
        {
          uuid: @element.css('guid').text,
          summary: @element.css('title').text,
          description: description,
          published_at: published_at,
          link: link
        }
      end

      private

      def link
        enclosure = @element.css('enclosure')

        return enclosure[0].attributes['url'].value unless enclosure.empty?

        @element.css('link')[0].attributes['href'].value
      end

      def description
        @element.children.max_by do |child|
          child.respond_to?(:text) ? child.text.length : 0
        end.text
      end

      def published_at
        DateTime.parse(@element.xpath('.//pubdate | .//published').first.text)
      end
    end

    def initialize(source_url)
      @source_url = source_url
    end

    def items
      Enumerator.new do |yielder|
        parsed.xpath('//rss/channel/item | //feed/entry').each do |element|
          yielder << Item.new(element).to_h
        end
      end
    end

    def title
      parsed.title
    end

    def image_url
      parsed.xpath('//rss/channel/image/url').text
    end

    private

    def parsed
      return @parsed unless @parsed.nil?

      response = HTTParty.get(@source_url)
      @parsed = Nokogiri::HTML(response.body)
      # switch to feed version of provided source
      feed_link_tag = @parsed.xpath('//head/link').select do |link|
        link.attributes["rel"].value == "alternate" && link.attributes["type"].value == "application/rss+xml"
      end.first

      if feed_link_tag
        response = HTTParty.get(feed_link_tag.attributes["href"].value).body
        @parsed = Nokogiri::HTML(response.body)
      else
        @parsed
      end
    end
  end
end