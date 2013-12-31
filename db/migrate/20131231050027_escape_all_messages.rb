require 'cgi'

class EscapeAllMessages < ActiveRecord::Migration
  def messages_under_consideration
    Message.where("time <= ?", Time.new(2013, 12, 31, 4, 45))
  end

  def e(s)
    CGI.escapeHTML(s)
  end

  def ue(s)
    CGI.unescapeHTML(s)
  end

  def up
    messages_under_consideration.each do |message|
      message.room = e(message.room)
      message.author = e(message.author)
      message.message = e(message.message)
      message.save!
    end
  end

  def down
    messages_under_consideration.each do |message|
      message.room = ue(message.room)
      message.author = ue(message.author)
      message.message = ue(message.message)
      message.save!
    end
  end
end
