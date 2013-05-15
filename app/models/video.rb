class Video < ActiveRecord::Base
  require "open-uri"
  belongs_to :room
  after_initialize :init
  attr_accessible :external_id, :length, :thumbnail_url, :title, :url, :video_url

  YOUTUBE_ID_REGEX = /(?:[0-9A-Z-]+\.)?(?:youtu\.be\/|youtube\.com\S*[^\w\-\s])([\w\-]{11})(?=[^\w\-]|$)(?![?=&+%\w]*(?:['"][^<>]*>|<\/a>))[?=&+%\w-]*/i

  validates :url, presence: true, format: YOUTUBE_ID_REGEX

  default_scope where("ended_at IS NULL")

  def init
    if self.new_record? and self.url[YOUTUBE_ID_REGEX, 1]
      info = YoutubeInfo.new(self.url[YOUTUBE_ID_REGEX, 1]).fetch
      self.assign_attributes info
    end
  end

  def as_json options = {}
    {
      id: self.id,
      title: self.title,
      length: self.length,
      url: self.url,
      thumbnail_url: self.thumbnail_url
    }
  end

end
