class ConnectionsController < ApplicationController

  def index
    @user = User.find(params[:user_id])
    connection_type = params[:connection_type]

    case connection_type
    when 'suggestions'
      @connections = Ep::Lib.get_suggestions(@user)
      @title = 'Suggestions'
    when 'friends'
      @connections = @user.friends
      @title = 'My Connections'
    when 'pending_invited'
      @connections = @user.pending_invited
      @title = 'Sent Requests'
    when 'pending_invited_by'
      @connections = @user.pending_invited_by
      @title = 'Invitations to Connect'
    end
  end
end
