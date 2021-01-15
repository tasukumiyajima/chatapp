class RoomsController < ApplicationController
  def index
    @rooms = Room.all.order(:id)
  end

  def new
    @room = Room.new
    @room.users << current_user
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @room = Room.find(params[:id])
    @messages = @room.messages.includes(:user).order(:id).last(100)
    # @room内のchecksをすべて削除する
    current_user.delete_checks_in(@room)
    # roomに入った段階で最新のメッセージをcheckする
    if latest_message = @room.messages.where.not(user_id: current_user.id).order(:id).last
      new_check = Check.create(user_id: current_user.id, message_id: latest_message.id)
    end
  end

  private

  def room_params
    params.require(:room).permit(:name).merge(user_ids: current_user.id)
  end
end
