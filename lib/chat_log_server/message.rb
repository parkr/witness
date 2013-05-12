class Message < ActiveRecord::Base
  attr_accessible :room, :author, :message, :at

  def self.latest(num = 10)
    find(:all, :order => "id desc", :limit => num)
  end

  def to_h
    {
      room: room,
      author: author,
      message: message,
      at: at.xmlschema
    }
  end
end
