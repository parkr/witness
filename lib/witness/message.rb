class Message < ActiveRecord::Base
  include Witness::ActiveRecordCache

  attr_accessible :room, :author, :message, :at

  def self.latest(num = 10, opts = {})
    options = {
      :order => "id desc",
      :limit => num
    }.merge(opts)
    without_skipped_authors
      .find(:all, options)
  end

  def self.search(query)
    without_skipped_authors
      .where(['message LIKE ?', "%#{query}%"])
      .order('id DESC')
      .group_by(&:room)
  end

  def self.by_author(author, limit)
    return {} if Witness.skip_authors.include?(author)
    without_skipped_authors
      .where(['author LIKE ?', author])
      .limit(limit)
      .order('id DESC')
      .group_by(&:room)
  end

  def self.without_skipped_authors
    skipped = Witness.skip_authors
    if skipped.empty?
      Message
    else
      where(['author NOT IN (?)', skipped])
    end
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
