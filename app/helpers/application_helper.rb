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
      icon = (user.as_org ? 'fa fa-university' : 'fa-user')

      content_tag(:div,
        content_tag(:i, "", class:"fa #{icon}", style:"font-size:#{font_size};" ),
        style: "width:#{width}px; height:#{height}px; background-color:#bdc3c7; color:white; border-radius:6px; padding: #{padding};"
      )
    else
      return image
    end
  end

end
