module ApplicationHelper

  def user_image(user, type = '', height, width)
    image = image_tag user.photo_url(type), onerror: "orgImgError(this);", height: height, width: width if user.as_org
    image = image_tag user.photo_url(type), onerror: "imgError(this);", height: height, width: width if !user.as_org

    if user.as_org
      case type
      when 'thumb'
        font_size = '30px'
        padding = '9px 0px 0px 9px'
      when 'medium'
        font_size = '80px'
        padding = '18px 0px 0px 18px'
      end
    else
      case type
      when 'thumb'
        font_size = '38px'
        padding = '5px 0px 0px 10px'
      when 'medium'
        font_size = '100px'
        padding = '10px 0px 0px 22px'
      end
    end

    if image.match('missing.png')
      icon = (user.as_org ? 'fa-university' : 'fa-user')

      content_tag(:span,
        content_tag(:i, "", class:"fa #{icon}", style:"font-size:#{font_size};" ),
        style: "width:#{width}px; height:#{height}px; background-color:#bdc3c7; color:white; border-radius:6px; padding: #{padding}; float:left; margin-botton:10px;"
      )
    else
      return image
    end
  end

  def place_of_work(experience)
    if experience.school.present?
      "at #{experience.school}"
    elsif experience.employer.present?
      "at #{experience.employer}"
    else
      ""
    end
  end

  def unsupported_browser?
    browser = Struct.new(:browser, :version)
    unsupported_browsers = [
      browser.new("Internet Explorer", "9.0"),
    ]

    user_agent = UserAgent.parse(request.env["HTTP_USER_AGENT"])
    unsupported_browsers.detect { |browser| user_agent <= browser }.present?
  end
end
