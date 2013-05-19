require 'cgi'

module ChatLogServer
  module Helpers
    module Urls
      def message_url(message)
        identifier = case message
        when Message
          message.id
        when Fixnum
          message
        end
        "/messages/#{identifier}"
      end

      def author_url(author)
        "/messages/by/#{author.to_s}"
      end

      def room_url(room)
        "/room/#{CGI.escape(room_name(room))}"
      end

      def link_to(text, url, attributes = {})
        "<a #{attributes.map{|k,v| "#{k}=#{v}"}.join('&')} href=\"#{url}\">#{text}</a>"
      end

      def room_name(input)
        if input[0] != "#"
          "##{input}"
        else
          input
        end
      end
    end
  end
end
