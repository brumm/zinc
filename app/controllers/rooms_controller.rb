class RoomsController < ApplicationController

  def index
    @rooms = Room.all
  end

  def show
    @room = Room.friendly.find(params[:id])

    gon.push({
      config: {
        room: @room.slug,
        videos: @room.videos.as_json,
        user: (current_user.as_json(resource: @room) || {}).as_json
      }
    })
  end

  def new
  end

  def create
    @room = Room.new(params[:room])
    if @room.save
      current_user.add_role(:owner, @room)
      redirect_to @room
    else
      render :new
    end
  end

  def edit
    @room = Room.find(params[:id])
  end

  def update
    @room = Room.find(params[:id])
    if @room.update_attributes(params[:room])
      redirect_to @room
    else
      render :new
    end
  end

  def destroy
    @room = Room.find(params[:id])
    @room.destroy
    redirect_to rooms_path
  end

end
