module ApplicationHelper

  def user_image(user, type = '', height, width)
    image_tag user.photo_url(type), onerror: "imgError(this);", height: height, width: width
  end

end
