class Message < ActiveRecord::Base
  include Witness::ActiveRecordCache

  attr_accessible :room, :author, :message, :at

  def self.latest(num = 10, opts = {})
    options = {
      :order => "id desc",
      :limit => num
    }.merge(opts)
    find(:all, options)
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
