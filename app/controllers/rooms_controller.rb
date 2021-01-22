class RoomsController < ApplicationController
  def index
    @rooms = Room.all.order("id DESC")
  end

  def new
    @room = Room.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @room = Room.new(room_params)
    @rooms = Room.all.order("id DESC")
    respond_to do |format|
      if @room.save
        format.html { redirect_to root_path }
        format.js
      else
        format.js { render :new }
      end
    end
  end

  def show
    @room = Room.find(params[:id])
    @messages = @room.messages.includes(:user).order(:id).last(10)
    # @room内のchecksをすべて削除する
    current_user.delete_checks_in(@room)
    # @roomの最新のメッセージをcheckする
    if latest_message = @room.messages.where.not(user_id: current_user.id).order(:id).last # rubocop:disable Lint/AssignmentInCondition
      Check.create(user_id: current_user.id, message_id: latest_message.id)
    end
  end

  def update_check
    @room = Room.find(params[:id])
    # @room内のchecksをすべて削除する
    current_user.delete_checks_in(@room)
    # @roomの最新のメッセージをcheckする
    if latest_message = @room.messages.where.not(user_id: current_user.id).order(:id).last # rubocop:disable Lint/AssignmentInCondition
      Check.create(user_id: current_user.id, message_id: latest_message.id)
    end
    last_id = params[:oldest_message_id].to_i
    latest_id = params[:latest_message_id].to_i
    @messages = @room.messages.includes(:user).order(:id).where(id: last_id..latest_id)
    render partial: 'new_messages', locals: { messages: @messages }
  end

  def show_additionally
    @room = Room.find(params[:id])
    last_id = params[:oldest_message_id].to_i - 1
    @messages = @room.messages.includes(:user).order(:id).where(id: 1..last_id).last(5)
    render partial: 'new_messages', locals: { messages: @messages }
  end

  def search
    if params[:room][:id].present?
      if searched_area = Room.find(params[:room][:id]) # rubocop:disable Lint/AssignmentInCondition
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

    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def room_params
    params.require(:room).permit(:name).merge(user_ids: current_user.id)
  end
end
