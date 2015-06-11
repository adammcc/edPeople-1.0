<% if flash[:alert] %>
<% flash[:alert].each do |alert| %>
_ep.notify.failure("<%= alert.html_safe %>")
<% end %>
<% else %>
$("#ep-confirm__add_password").modal('hide');
<% end %>
