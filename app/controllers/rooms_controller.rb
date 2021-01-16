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

  def search
    if params[:room][:id].present?
      if searched_area = Room.find(params[:room][:id])
        @searched_area = searched_area.name
      else
        @searched_area = "全てのチャットルーム"
      end
    else
      @searched_area = "全てのチャットルーム"
    end

    if params[:room][:search].present?
      searched_messages = Message.search(params[:room][:search], params[:room][:id])
      if searched_messages.any?
        @messages = searched_messages
        @searched_word = params[:room][:search]
      else
        @messages = Message.none
        @searched_word = params[:room][:search]
        flash.now[:info] = "条件に一致するメッセージは見つかりませんでした"
      end
    else
      flash[:danger] = "検索ワードを入力してください"
      redirect_to request.referrer || root_url
    end
  end

  private

  def room_params
    params.require(:room).permit(:name).merge(user_ids: current_user.id)
  end
end
