require "open-uri"

class YoutubeInfo

  def initialize(youtube_id)
    @youtube_id = youtube_id
    @intermediate = HashWithIndifferentAccess.new
    @youtube_info = HashWithIndifferentAccess.new
  end

  def fetch
    raw_response
    parse_response

    {
      url: "http://www.youtube.com/watch?v=#{@youtube_id}",
      title: @intermediate[:title].first,
      length: @intermediate[:length_seconds].first,
      thumbnail_url: @intermediate[:thumbnail_url].first
      # stream_urls: parse_stream_map
    }
  end

  private

  def raw_response
    @intermediate = open("http://www.youtube.com/get_video_info?video_id=#{@youtube_id}").read
  end

  def parse_response
    @intermediate = CGI::parse(@intermediate).with_indifferent_access
    @intermediate[:url_encoded_fmt_stream_map] = CGI::parse(@intermediate[:url_encoded_fmt_stream_map].first).with_indifferent_access
  end

  def parse_stream_map
    video_info = HashWithIndifferentAccess.new
    @intermediate[:url_encoded_fmt_stream_map][:type].each.with_index do |type, index|
      begin
        quality = @intermediate[:url_encoded_fmt_stream_map][:quality][index][/^(\w+),/, 1]
        url     = @intermediate[:url_encoded_fmt_stream_map][:url][index]
        sig     = @intermediate[:url_encoded_fmt_stream_map][:sig][index]

        key             = "#{type[/video\/([a-z-]+);?/, 1]}-#{quality}"
        video_info[key] = { url: "#{url}&signature=#{sig}" }
      rescue
        binding.pry
      end
    end
    video_info
  end

end
