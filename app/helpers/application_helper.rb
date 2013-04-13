module ApplicationHelper

  def glyph(*names)
    content_tag :i, nil, class: names.map {|name| "icon-#{name.to_s.gsub('_','-')}" }
  end

  def icon_link_to(*args, &block)
    if block_given?
      options      = args.first || {}
      html_options = args.second
      icon         = html_options.delete(:icon)

      link_to("#{glyph(icon)}#{capture(&block)}".html_safe, options, html_options)
    else
      name         = args[0]
      options      = args[1] || {}
      html_options = args[2]
      icon = html_options.delete(:icon)

      html_options = convert_options_to_data_attributes(options, html_options)
      url = url_for(options)

      href = html_options['href']
      tag_options = tag_options(html_options)

      href_attr = "href=\"#{ERB::Util.html_escape(url)}\"" unless href
      "<a #{href_attr}#{tag_options}>#{glyph(icon)}#{ERB::Util.html_escape(name || url)}</a>".html_safe
    end
  end

end
